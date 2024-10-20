import os
from twitchio.ext import commands
from dotenv import load_dotenv

import configparser

load_dotenv()

twitch_channel = os.environ.get('TWITCH_CHANNEL')
twitch_token = os.environ.get('TWITCH_TOKEN')
print(f"Using token: {twitch_token}")
config = configparser.ConfigParser()

class Bot(commands.Bot):

    def __init__(self):
        super().__init__(token=twitch_token, prefix='!', initial_channels=[twitch_channel])

    async def event_ready(self):
        print(f'Logged in as | {self.nick}')
        print('Twitch bot is online!')
    
    @commands.command()
    async def hello(self, ctx: commands.Context):
        # Here we have a command hello, we can invoke our command with our prefix and command name
        # e.g ?hello
        # We can also give our commands aliases (different names) to invoke with.

        # Send a hello back!
        # Sending a reply back to the channel is easy... Below is an example.
        print(ctx.author.name)
        await ctx.send(f'Hello {ctx.author.name}!')

    @commands.command(name='attack')
    async def attack_command(self, ctx):
        print(f'{ctx.author.name} issued an attack command!')
        await self.send_to_arma('attack')

    @commands.command(name='defend')
    async def defend_command(self, ctx):
        print(f'{ctx.author.name} issued a defend command!')
        await self.send_to_arma('defend')

    @commands.command(name='spawn')
    async def spawn_command(self, ctx):
        print(f'{ctx.author.name} issued a spawn command!')
        await self.send_to_arma('spawn')

    async def send_to_arma(self, command):
        print(f"Sending command to Arma 3: {command}")
        config.read("E:/Games/Steam/steamapps/common/Arma 3/!Workshop/@INIDBI2 - Official extension/db/76561198013495507.ini")

        if not config.has_section('Viewer Command'):
            config.add_section('Viewer Command')
            config.set('Viewer Command', 'command', f'""{command}""')
        else:
            config.set('Viewer Command', 'command',  f'""{command}""')
        
        with open('E:/Games/Steam/steamapps/common/Arma 3/!Workshop/@INIDBI2 - Official extension/db/76561198013495507.ini', 'w') as configfile:
            config.write(configfile)

bot = Bot()
bot.run()

