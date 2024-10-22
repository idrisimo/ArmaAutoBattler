import configparser

config = configparser.ConfigParser()

def join_new_player(command):
    twitch_username = command[0]
    
    config.read("E:/Games/Steam/steamapps/common/Arma 3/!Workshop/@INIDBI2 - Official extension/db/database.ini")

    if not config.has_section("Team Status"):
        config.add_section("Team Status")
    
    if not config.has_option("Team Status", twitch_username):
        command_type = command[1]
        config.set("Team Status", twitch_username, f"['fireTeam', '{command_type}', '', 'new']")
        with open('E:/Games/Steam/steamapps/common/Arma 3/!Workshop/@INIDBI2 - Official extension/db/database.ini', 'w') as configfile:
            config.write(configfile)
    else:
        print("user has already joined")
        
def get_group_status(twitch_username):
    config.read("E:/Games/Steam/steamapps/common/Arma 3/!Workshop/@INIDBI2 - Official extension/db/database.ini")
    if config.has_option(twitch_username):
        return config.get("Team Status", twitch_username)
    else:
        return ""

def write_command_to_db(command):
    twitch_username = command[0]
    command_type = command[1]
    command_objective = command[2]
    print(f"writing command to database")
    config.read("E:/Games/Steam/steamapps/common/Arma 3/!Workshop/@INIDBI2 - Official extension/db/database.ini")
    
    if not config.has_section("Team Status"):
        config.add_section("Team Status")
        
    config.set("Team Status", twitch_username, f"['fireTeam', '{command_type}', '{command_objective}', 'idle']")
    
    with open('E:/Games/Steam/steamapps/common/Arma 3/!Workshop/@INIDBI2 - Official extension/db/database.ini', 'w') as configfile:
        config.write(configfile)


