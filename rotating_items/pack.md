# Rotating Items
This resourcepack rotates items in the inventory. Works in 1.17+ with vanilla shaders.
Optifine not required.

Compactible with other resourcepacks.

## Configuration
You may configure some settings in <pack>/assets/minecraft/shaders/include/config.glsl:
```glsl
#define ROTATE_SPEED 1200           //Rotating Speed

//Rotates in ... (comment/uncomment with "//" to switch on/off)
#define ADVANCEMENT_POPOUT          //Advancement pop-out icons
//#define ADVANCEMENT_ICON_SELECTED   //Selected advancement's icons
#define ON_CURSOR                   //Items Dragged by cursor
#define INVENTORY                   //Items in Inventory (thanks, cap)
//#define ADVANCEMENT_ICON            //Advancement's icons
#define HOTBAR                      //Items in hotbar     

//Type (comment/uncomment to switch) || Don't switch off both lines
#define FLAT                        //Flat Items
#define MODEL                       //Blocks

```
