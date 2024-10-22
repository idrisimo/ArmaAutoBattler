import os
from twitchio.ext import commands
from dotenv import load_dotenv

import configparser

from utils.helper import handle_unit_command, handle_joining_game, handle_check_user_exists
from arma_bridge import write_command_to_db, join_new_player, get_group_status

load_dotenv()

twitch_channel = os.environ.get('TWITCH_CHANNEL')
twitch_token = os.environ.get('TWITCH_TOKEN')
print(f"Using token: {twitch_token}")
config = configparser.ConfigParser()

class Bot(commands.Bot):

    def __init__(self):
        super().__init__(token=twitch_token, prefix='!', initial_channels=[twitch_channel])
        self.write_command_to_db = write_command_to_db
        self.join_new_player = join_new_player
        self.get_group_status = get_group_status

    async def event_ready(self):
        print(f'Logged in as | {self.nick}')
        print('Twitch bot is online!')
    
    @commands.command()
    async def hello(self, ctx: commands.Context):
        print(ctx.author.name)
        await ctx.send(f'Hello {ctx.author.name}!')

    @commands.command(name='attack', aliases="Attack")
    async def attack_command(self, ctx, objective):
        user_exists = handle_check_user_exists(ctx, self)
        if user_exists:
            await handle_unit_command(ctx, 'attack', objective, self)
        else:
            # TODO add function for whisper to viewer
            pass

    @commands.command(name='defend', aliases="Defend")
    async def defend_command(self, ctx, objective):
        user_exists = handle_check_user_exists(ctx, self)
        if user_exists:
            await handle_unit_command(ctx, 'defend', objective, self)
        else:
            # TODO add function for whisper to viewer
            pass

    
    @commands.command(name='join')
    async def join_game(self, ctx):
        user_exists = handle_check_user_exists(ctx, self)
        if not user_exists:
            await handle_joining_game(ctx, 'joinGame', self)
        else:
            # TODO add function for whisper to viewer
            pass
bot = Bot()
bot.run()

