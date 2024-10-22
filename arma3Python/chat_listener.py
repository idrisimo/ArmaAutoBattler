import os
from twitchio.ext import commands
from dotenv import load_dotenv

import configparser

from utils.helper import handle_unit_command, handle_unit_spawning
from arma_bridge import write_command_to_db

load_dotenv()

twitch_channel = os.environ.get('TWITCH_CHANNEL')
twitch_token = os.environ.get('TWITCH_TOKEN')
print(f"Using token: {twitch_token}")
config = configparser.ConfigParser()

class Bot(commands.Bot):

    def __init__(self):
        super().__init__(token=twitch_token, prefix='!', initial_channels=[twitch_channel])
        self.write_command_to_db = write_command_to_db

    async def event_ready(self):
        print(f'Logged in as | {self.nick}')
        print('Twitch bot is online!')
    
    @commands.command()
    async def hello(self, ctx: commands.Context):
        print(ctx.author.name)
        await ctx.send(f'Hello {ctx.author.name}!')

    @commands.command(name='attack', aliases="Attack")
    async def attack_command(self, ctx, objective):
        await handle_unit_command(ctx, 'attack', objective, self)

    @commands.command(name='defend')
    async def defend_command(self, ctx, objective):
        await handle_unit_command(ctx, 'defend', objective, self)

    @commands.command(name='spawn')
    async def spawn_command(self, ctx, objective):
        await handle_unit_spawning(ctx, 'spawn', self)

bot = Bot()
bot.run()

