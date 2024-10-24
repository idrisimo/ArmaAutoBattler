import configparser

config = configparser.ConfigParser()

def send_to_arma(command):
    print(f"Sending command to Arma 3: {command[1]}")
    config.read("E:/Games/Steam/steamapps/common/Arma 3/!Workshop/@INIDBI2 - Official extension/db/database.ini")

    if not config.has_section('Viewer Command'):
        config.add_section('Viewer Command')
    
    config.set('Viewer Command', 'command', f'""{command[1]}""')
    
    with open('E:/Games/Steam/steamapps/common/Arma 3/!Workshop/@INIDBI2 - Official extension/db/database.ini', 'w') as configfile:
        config.write(configfile)
