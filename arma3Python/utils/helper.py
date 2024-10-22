

async def handle_unit_command(ctx, command_type, objective, bot):
    print(f'{ctx.author.name} issued a {command_type} command on objective {objective}!')
    # await bot.send_to_arma([ctx.author.name, command_type, objective])
    bot.write_command_to_db([ctx.author.name, command_type, objective])

async def handle_unit_spawning(ctx, command_type, bot):
        print(f'{ctx.author.name} joined the fight!')
        await bot.send_to_arma([ctx.author.name, command_type])
