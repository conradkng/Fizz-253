/*This state is for adjusting the settings of INDY*/
boolean SETTINGS_init = false;
enum Setting { FLATSPEED, FT_KP, FT_KD, CI_C_START, CI_C_DOWN, CI_C_UP, CI_C_DROP, CI_R_WITHDRAWN, CI_R_EXTEND, 
                HILLSPEED, CH_ON_HILL, CH_OFF_HILL, CH_DURATION, EDGE_HEIGHT, SPINSPEED, SWEEP_DUR, SWEEP_OFF, 
                IR_THRESH, ROCKSPEED, RP_KP, RP_KI, RP_KD, CLEAR, NO_SETTING };
Setting settingChoice = NO_SETTING;
Setting currentSetting = NO_SETTING;
double value;

void SETTINGS_setup()
{
  if(!SETTINGS_init)
  {
    SETTINGS_init = true;
    settingChoice = NO_SETTING;
    currentSetting = NO_SETTING;
    motor.stop_all();
    delay(200);
  }
}

void SETTINGS_exit()
{
  SETTINGS_init = false;
  SaveSettings();
  delay(200);
}

void updateSettings()
{
  if (currentSetting == NO_SETTING)
  {
    settingChoice = (Setting)((int)(map(knob(6), 0, KNOB6_MAX, 0, NO_SETTING)));
    settingChoice = (Setting)constrain(settingChoice, 0, NO_SETTING-1);
    
    if(startbutton())
    {
      if(settingChoice == CLEAR)
      {
        ClearSavedSettings();
        LCD.clear(); LCD.home();
        LCD.print("Settings");
        LCD.setCursor(0,1); LCD.print("Cleared!");
        delay(1000);
        LCD.clear(); LCD.home();
        LCD.print("Press RESET");
        LCD.setCursor(0,1); LCD.print("for Defaults");
        delay(1000);
      }
      else
      {
        LCD.clear(); LCD.print("...");
        currentSetting = settingChoice;
        delay(500);
      }
    }
  }
  else
  {
  
    switch(currentSetting)
    {
      case CI_C_START:
      case CI_C_DOWN:
      case CI_C_UP:
      case CI_C_DROP:
      case CI_R_WITHDRAWN:
      case CI_R_EXTEND:
        value = map(knob(6), 0, KNOB6_MAX, 0, 180);
        break;
      case CH_ON_HILL:
      case CH_OFF_HILL:
        value = map(knob(6), 0, KNOB6_MAX, 0, 10.0);
        break;
      case CH_DURATION:
        value = map(knob(6), 0, KNOB6_MAX, 0, 5000.0);
        break;
      case EDGE_HEIGHT:
        value = map(knob(6), 0, KNOB6_MAX, 0, 100.0);
        break;
      default:
        value = knob(6);
        break;
    }
    
    if (startbutton())
    {
      SetSetting(currentSetting, value);
      
      //Notify that setting has been set
      LCD.clear();
      LCD.home();
      LCD.print(GetSettingName(currentSetting));
      LCD.setCursor(0,1); LCD.print("set to:");LCD.print(GetSettingValue(currentSetting));
      
      delay(1000);
      
      currentSetting = NO_SETTING;
    }
  }
}

///////SETTINGS LCD/////////

void settings_LCD()
{
  switch(currentSetting)
  {
    case NO_SETTING:
      if(settingChoice == CLEAR)
      {
        LCD.print("Clear Saved");
        LCD.setCursor(0,1); LCD.print("Settings");
      }
      else
      {
        LCD.print("Set: "); LCD.print(GetSettingName(settingChoice)); 
        LCD.setCursor(0,1); LCD.print("("); LCD.print(GetSettingValue(settingChoice)); LCD.print(")");
      }
      break;
    default:
      LCD.print("{"); LCD.print(GetSettingName(currentSetting)); LCD.print("}:");
      LCD.setCursor(0,1);LCD.print(value);
  }
}

void SetSetting(int settingAsInt, double value)
{
  Setting setting = (Setting)settingAsInt;
  
  switch(setting)
  {
    case FLATSPEED:
      FLAT_SPEED = (int)value;
      break;
    case FT_KP:
      kP = (int)value;
      break;
    case FT_KD:
      kD = (int)value;
      break;
    case CI_C_START:
      COLLECTOR_START = (int)value;
      break;
    case CI_C_DOWN:
      COLLECTOR_DOWN = (int)value;
      break;
    case CI_C_UP:
      COLLECTOR_TOP = (int)value;
      break;
    case CI_C_DROP:
      COLLECTOR_DROP = (int)value;
      break;
    case CI_R_WITHDRAWN:
      RETRIEVER_WITHDRAWN = (int)value;
      break;
    case CI_R_EXTEND:
      RETRIEVER_EXTEND = (int)value;
      break;
    case HILLSPEED:
      HILL_SPEED = (int)value;
      break;
    case CH_ON_HILL:
      ON_HILL = value;
      break;
    case CH_OFF_HILL:
      OFF_HILL = value;
      break;
    case CH_DURATION:
      DURATION = value;
      break;
    case EDGE_HEIGHT:
      DANGER_HEIGHT = value;
      break;
    case SPINSPEED:
      SPIN_SPEED = value;
      break;
    case SWEEP_DUR:
      SWEEP_DURATION = (int)value;
      break;
    case SWEEP_OFF:
      SWEEP_OFFSET = (int)value;
      break;
    case IR_THRESH:
      IR_THRESHOLD = (int)value;
      break;
    case ROCKSPEED:
      ROCK_SPEED = (int)value;
      break;
    case RP_KP:
      beacon_kP = (int)value;
      break;
    case RP_KI:
      beacon_kI = (int)value;
      break;
    case RP_KD:
      beacon_kD = (int)value;
      break;
    default:
      break;
  }
}

String GetSettingName(int settingAsInt)
{
  Setting setting = (Setting)settingAsInt;
  switch(setting)
  {
    case FLATSPEED:
      return "Flat Speed";
    case FT_KP:
      return "FT kP";
    case FT_KD:
      return "FT kD";
    case CI_C_START:
      return "C Arm Start";
    case CI_C_DOWN:
      return "C Arm Down";
    case CI_C_UP:
      return "C Arm Up";
    case CI_C_DROP:
      return "C Arm Drop";
    case CI_R_WITHDRAWN:
      return "R Arm Pull";
    case CI_R_EXTEND:
      return "R Arm Down";
    case HILLSPEED:
      return "Hill Speed";
    case CH_ON_HILL:
      return "On Hill";
    case CH_OFF_HILL:
      return "Off Hill";
    case CH_DURATION:
      return "CH Duration";
    case EDGE_HEIGHT:
      return "Edge";
    case SPINSPEED:
      return "Spin Speed";
    case SWEEP_DUR:
      return "Sweep Dur";
    case SWEEP_OFF:
      return "Sweep Off";
    case IR_THRESH:
      return "IR Thresh";
    case ROCKSPEED:
      return "Rock Speed";
    case RP_KP:
      return "Beacon kP";
    case RP_KI:
      return "Beacon kI";
    case RP_KD:
      return "Beacon kD";
    default:
      return "INVALID";
  }
}

double GetSettingValue(int settingAsInt)
{
  Setting setting = (Setting)settingAsInt;
  switch(setting)
  {
    case FLATSPEED:
      return FLAT_SPEED;
    case FT_KP:
      return kP;
    case FT_KD:
      return kD;
    case CI_C_START:
      return COLLECTOR_START;
    case CI_C_DOWN:
      return COLLECTOR_DOWN;
    case CI_C_UP:
      return COLLECTOR_TOP;
    case CI_C_DROP:
      return COLLECTOR_DROP;
    case CI_R_WITHDRAWN:
      return RETRIEVER_WITHDRAWN;
    case CI_R_EXTEND:
      return RETRIEVER_EXTEND;
    case HILLSPEED:
      return HILL_SPEED;
    case CH_ON_HILL:
      return ON_HILL;
    case CH_OFF_HILL:
      return OFF_HILL;
    case CH_DURATION:
      return DURATION;
    case EDGE_HEIGHT:
      return DANGER_HEIGHT;
    case SPINSPEED:
      return SPIN_SPEED;
    case SWEEP_DUR:
      return SWEEP_DURATION;
    case SWEEP_OFF:
      return SWEEP_OFFSET;
    case IR_THRESH:
      return IR_THRESHOLD;
    case ROCKSPEED:
      return ROCK_SPEED;
    case RP_KP:
      return beacon_kP;
    case RP_KI:
      return beacon_kI;
    case RP_KD:
      return beacon_kD;
    default:
      return 1337;
  }
}

/////SAVING AND LOADING///////

void SaveSettings()
{
  for(int setting=0; setting < CLEAR; setting++)
  {
    EEPROM.updateDouble(setting*sizeof(double), GetSettingValue(setting));
  }
  
  EEPROM.write(CLEAR*sizeof(double), 's'); //S means settings have been saved
}

void LoadSettings()
{
  
  LCD.clear();
  LCD.home();
  LCD.print("Loading");
  LCD.setCursor(0,1);
  LCD.print("Settings...");
  delay(1000);
  
  for(int setting=0; setting < CLEAR; setting++)
  {
    if(EEPROM.readDouble(setting*sizeof(double)) != GetSettingValue(setting))
    {
      LCD.clear();
      LCD.home();
      LCD.print(GetSettingName(setting));
      LCD.setCursor(0,1);
      SetSetting(setting, EEPROM.readDouble(setting*sizeof(double)));
      LCD.print(GetSettingValue(setting));
      delay(700);
    }
    
  }
  
  
  LCD.clear();
  LCD.home();
  LCD.print("...");
  delay(1000);
}

inline boolean hasSavedSettings()
{
  return (EEPROM.read(CLEAR*sizeof(double)) == 's');
}

void ClearSavedSettings()
{
  EEPROM.write(CLEAR*sizeof(double), 0);
}
