

async def handle_unit_command(ctx, command_type, objective, bot):
    print(f'{ctx.author.name} issued a {command_type} command on objective {objective}!')
    bot.write_command_to_db([ctx.author.name, command_type, objective])

async def handle_joining_game(ctx, command_type, bot):
    print(f'{ctx.author.name} joined the fight!')
    bot.join_new_player([ctx.author.name, command_type])

# Checks if player has already joined the game
async def handle_check_user_exists(ctx, bot):
    data = bot.get_group_status(ctx.author.name)
    if data:
        return True
    else:
        return False
