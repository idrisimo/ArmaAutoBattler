import os
import requests
from twitchio.ext import commands
from twitchio.channel import Channel
from dotenv import load_dotenv

import configparser

from utils.helper import handle_unit_command, handle_joining_game, handle_check_user_exists
import arma_bridge as ab

load_dotenv()

twitch_channel = os.environ.get('TWITCH_CHANNEL')
twitch_token = os.environ.get('TWITCH_TOKEN')
client_id = os.environ.get('CLIENT_ID')
print(f"Using token: {twitch_token}")
config = configparser.ConfigParser()

class Bot(commands.Bot):

    def __init__(self):
        super().__init__(token=twitch_token, prefix='!', initial_channels=[twitch_channel])
        self.write_command_to_db = ab.write_command_to_db
        self.join_new_player = ab.join_new_player
        self.get_group_status = ab.get_group_status

    async def event_ready(self):
        print(f'Logged in as | {self.nick}')
        print('Twitch bot is online!')
    
    @commands.command()
    async def hello(self, ctx: commands.Context):
        print(ctx.author.name)
        await ctx.send(f'Hello {ctx.author.name}!')
    
    async def event_command_error(self, ctx: commands.Context, error: Exception) -> None:
        # return await super().event_command_error(context, error)
        await ctx.send(f" uhoh {ctx.author.name}, something went wrong: {error}")
    
    @commands.command(name='attack', aliases="Attack")
    @commands.cooldown(3, 45, commands.Bucket.user)
    async def attack_command(self, ctx, objective):
        user_data = self.get_group_status(ctx.author.name)
        if user_data:
            print(f"player exists, writing command to db")
            await handle_unit_command(ctx, 'attack', objective, self)
            print(f"Command 'attack' objective {objective} written for {ctx.author.name}")
        else:
            # TODO add function for whisper to viewer
            print(f"player doesn't exists yet")

    @commands.command(name='defend', aliases="Defend")
    @commands.cooldown(3, 45, commands.Bucket.user)
    async def defend_command(self, ctx, objective):
        user_data = self.get_group_status(ctx.author.name)
        if user_data:
            print(f"player exists, writing command to db")
            await handle_unit_command(ctx, 'defend', objective, self)
            print(f"Command 'defend' written for {ctx.author.name}")
        else:
            # TODO add function for whisper to viewer
            print(f"player doesn't exists yet")


    
    @commands.command(name='join')
    @commands.cooldown(3, 45, commands.Bucket.user)
    async def join_game(self, ctx):
        user_data = self.get_group_status(ctx.author.name)
        if not user_data:
            await handle_joining_game(ctx, 'joinGame', self)
        else:
            # TODO add function for whisper to viewer
            print(f"player already exists")
bot = Bot()
bot.run()

