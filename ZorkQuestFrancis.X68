 org $1000

*-------------------------------------------------------
*Choose to be Evil Wizard or New Romancers
*-------------------------------------------------------

*-------------------------------------------------------
*Validation values to be used, modify as needed
*Add additional validation values as required
*-------------------------------------------------------
exit        EQU 0      used to exit assembly program
min_feed    EQU 100    min feed requirement
min_horses  EQU 1      min number of horses
max_horses  EQU 9      max number of horses
min_soldier EQU 6      min soldiers
min_charge  EQU 1      min rate of fuel use based of speed (oats for horses)
max_charge  EQU 5      max rate e.g. Flank       
hit_point   EQU 5      points accumilated on castle (objective) strike
miss_point  EQU 8      points deducted for ordinace miss

mine_loc    EQU 100    example for a hit


*Start of Game
start:
    move.b  #100,$4000 put money in memory location $4000
    move.b  #0,D5 *checks to see what path the player is on
    lea     $4000,A3   assign address A3 to that memory location
    
    bsr     welcome    branch to the welcome subroutine
    bsr     Name      *th eintroduction chapter to the game
   * bsr     input      branch to the input subroutine
   * bsr     game       branch to the game subroutine
*Game loop
    org     $3000      the rest of the program is to be located from 3000 onwards

*-------------------------------------------------------
*-------------------Game Subroutine---------------------
*-------------------------------------------------------
game:
    bsr     gameloop   branch to gameloop subroutine
    rts                return from game: subroutine
          
end:
    simhalt

*-------------------------------------------------------
*-------------------Welcome Subroutine------------------
*-------------------------------------------------------
welcome:
    bsr     endl            branch to endl subroutine
    lea     welcome_msg,A1  assign message to address register A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15             trap and interpret value in D0
    bsr     endl            branch to endl subroutine
    rts                     return from welcome: subroutine
*-------------------------------------------------------
*---------NAme Input------------------------------------
*-------------------------------------------------------
Name:
    lea     ask_name,A1 *loads in the introduction of the game
    move.b  #14,D0         
    trap    #15

    move.b  #2,D0 *name input        
    trap    #15
    
    move.b  #1,D0 *display name         
    trap    #15
    
    move.w  A1,A2 *moves the name form A1 to A2 

    lea     accept_name,A1 *loads in the introduction of the game
    move.b  #14,D0         
    trap    #15
    
    lea     crlf,A1 *loads in the introduction of the game
    move.b  #14,D0         
    trap    #15
    
    bsr Intro
    rts
    
*-------------------------------------------------------
*---------Game Intro------------------------------------
*-------------------------------------------------------

Intro:
    lea     intro_msg,A1 *loads in the introduction of the game
    move.b  #14,D0         
    trap    #15

    move.b  #4,D0 *number input and compares         
    trap    #15
    
    move.b D1,D2 

    cmp #1,D2
    beq     Good
    
    cmp #2,D2
    beq     Evil
    
    cmp #3,D2
    beq     Neutral
    rts
*-------------------------------------------------------
*---------Good Path------------------------------------
*-------------------------------------------------------

Good:
    bsr decorate
    
    move.b #1,D5
    
    lea good_ch1_p1,A1
    move.b  #14,D0         
    trap    #15
    
    bsr stable
    
    lea good_ch1_p2,A1
    move.b  #14,D0         
    trap    #15
    
    bsr epilouge
    
    rts
*-------------------------------------------------------
*---------Neutral Path------------------------------------
*-------------------------------------------------------

Neutral:
    bsr decorate
    
    lea neutral_ch1_p1,A1
    move.b  #14,D0         
    trap    #15

    move.b  #4,D0 *number input and compares         
    trap    #15
    
    move.b D1,D2
    
    cmp #0,D2 *if its not equal to 0 it closes
    beq Intro
    bgt Exit
    blt Exit

    rts
*-------------------------------------------------------
*---------Evil Path------------------------------------
*-------------------------------------------------------

Evil:
    bsr decorate
    
    move.b #2,D5 *puts the path to the evil path
    
    lea evil_ch1_p1,A1
    move.b  #14,D0         
    trap    #15
    
    bsr stable
    
    lea evil_ch1_p2,A1
    move.b  #14,D0         
    trap    #15
    
    bsr epilouge
    
    rts
    
*-------------------------------------------------------
*---------stable horses---------------------------------
*-------------------------------------------------------
Stable:
    lea crlf,A1
    move.b  #14,D0         
    trap    #15

    lea stable_1,A1
    move.b  #14,D0         
    trap    #15
    
    lea crlf,A1
    move.b  #14,D0         
    trap    #15
 
    lea gold_amount,A1
    move.b  #14,D0         
    trap    #15
    
    move.b $4000,D1
    
    move.b  #3,D0         
    trap    #15
    
    lea crlf,A1
    move.b  #14,D0         
    trap    #15
    
    bsr Buyfeed
    
    rts
    
*-------------------------------------------------------
*checks if the number is less than the amount of money
*-------------------------------------------------------

Buyfeed:
    lea feed_amount,A1
    move.b  #14,D0         
    trap    #15
    
    move.b  #4,D0 *number input        
    trap    #15

    move.b D1,D6
    
    move.b $4000,D4
    
    cmp D4,D6
    bge Error
    blt Checkbetweenfifty
    
    rts

*-------------------------------------------------------
*checks if the number is greater than the amount to get to the castle
*-------------------------------------------------------
Checkbetweenfifty:
    cmp #50,D6
    bge BoughtFeed
    blt Error
    
    rts
    
*-------------------------------------------------------
*if the number is greater than ur money or less than fifty go again
*-------------------------------------------------------
Error:
    lea stable_wrong,A1
    move.b  #14,D0         
    trap    #15
    
    bsr Buyfeed
    rts


*-------------------------------------------------------
*buys the feed of the stable hand
*-------------------------------------------------------
Boughtfeed:
    sub.b D6, $4000

    lea gold_amount,A1
    move.b  #14,D0         
    trap    #15
    
    move.b $4000,D1
    
    move.b  #3,D0         
    trap    #15
    
    lea crlf,A1
    move.b  #14,D0         
    trap    #15
    
    lea stable_buy,A1
    move.b  #14,D0         
    trap    #15
    
    move.b D6,D1
    
    move.b  #3,D0         
    trap    #15
    
    lea word_feed,A1
    move.b  #14,D0         
    trap    #15
    
    lea stable_end,A1
    move.b  #14,D0         
    trap    #15
    
    lea feed_current,A1
    move.b  #14,D0         
    trap    #15
    
    move.b D6,D1
    
    move.b  #3,D0         
    trap    #15
    
    lea word_feed,A1
    move.b  #14,D0         
    trap    #15
    
    lea crlf,A1
    move.b  #14,D0         
    trap    #15
    
    lea departure_msg,A1
    move.b  #14,D0         
    trap    #15
    
    move.b  #4,D0         
    trap    #15
    
    move.b D1,D2
    
    cmp #1,D2
    beq departure
    blt Buyfeed
    
    rts


departure:
    sub.b   #50,D6 *current amout of feed minus cost to castle

    lea feed_current,A1
    move.b  #14,D0         
    trap    #15
    
    move.b D6,D1
    
    move.b  #3,D0         
    trap    #15
    
    lea word_feed,A1
    move.b  #14,D0         
    trap    #15
    
    lea crlf,A1
    move.b  #14,D0         
    trap    #15

    rts
    
epilouge:
    lea crlf,A1
    move.b  #14,D0         
    trap    #15

    lea epilouge_1,A1
    move.b  #14,D0         
    trap    #15
    
    bsr riddlep1
    
    rts

riddlep1:
    lea crlf,A1
    move.b  #14,D0         
    trap    #15

    lea riddle_1,A1
    move.b  #14,D0         
    trap    #15
    
    move.b  #4,D0         
    trap    #15
    
    cmp #0,D1
    beq riddlep2
    blt riddlep1

riddlep2:
    lea crlf,A1
    move.b  #14,D0         
    trap    #15

    lea riddle_2,A1
    move.b  #14,D0         
    trap    #15
    
    move.b  #4,D0         
    trap    #15
    
    cmp #18,D1
    beq riddlep3
    blt riddlep2
    
riddlep3:
    lea crlf,A1
    move.b  #14,D0         
    trap    #15

    move.w A2,A1
    
    move.b  #1,D0         
    trap    #15
    
    move.w A1,A2

    lea riddle_3,A1
    move.b  #14,D0         
    trap    #15
    
    move.b  #4,D0         
    trap    #15
    
    cmp #5,D1
    beq ending_1
    blt riddlep3
    
    
ending_1:
    lea crlf,A1
    move.b  #14,D0         
    trap    #15

    move.l A2,A1
    
    move.b  #1,D0         
    trap    #15

    lea ending,A1
    move.b  #14,D0         
    trap    #15
    
    lea replay_msg,A1
    move.b  #14,D0         
    trap    #15

    move.b  #4,D0         
    trap    #15
    
    cmp #1,D1
    beq Name
    blt Exit
    
    rts

*-------------------------------------------------------
*---------Gameplay Input Values Subroutine--------------
*-------------------------------------------------------    
input:
    bsr     feed            branch to feed input subroutine
    bsr     horses          branch to ship input subroutine
    bsr     rate            branch to rate (charging speed) input subroutine
    bsr     distance        branch to mission distance/location input subroutine
    bsr     soldiers        branch to soldiers input subroutine
    bsr     check_health    branch to check the health 
    rts

*-------------------------------------------------------
*----------------Gameloop (main loop)-------------------
*------------------------------------------------------- 
gameloop:
    bsr     update          branch to update game subroutine 
    bsr     clear_screen    clears the screen         
    bsr     draw            branch to draw screen subroutine
    bsr     clear_screen    clears the screen
    bsr     gameplay        branch to gameplay subroutine
    bsr     clear_screen    clears the screen
    bsr     hud             branch to display HUD subroutine
    bsr     clear_screen    clears the screen
    bsr     replay          branch to replay game subroutine
    bsr     clear_screen    clears the screen
    rts                     return from gameloop: subroutine

*-------------------------------------------------------
*---------------Update Mission Progress-----------------
*  Move to battle location, engage enemy, fire and take
*  fire, complete mission and return to base
*------------------------------------------------------- 
update:
    bsr     endl            print a CR and LF
    bsr     decorate        decorate with dots using a loop
    lea     update_msg,A1   
    move.b  #14,D0
    trap    #15
    bsr     decorate
    rts
*-------------------------------------------------------
*---------------Draw Mission Updates--------------------
* Draw the game progress information, status regarding
* mission
*------------------------------------------------------- 
draw:
    bsr     endl
    bsr     decorate
    lea     draw_msg,A1
    move.b  #14,D0
    trap    #15
    bsr     decorate
    rts
*-------------------------------------------------------
*-----------------------Horse feed-----------------------
* Input the feed load for each horse. Feed costs money
* For an advanced mark you need to manage this resource
*------------------------------------------------------- 
feed:
    bsr     endl
    bsr     decorate
    lea     feed_msg,A1
    move.b  #14,D0
    trap    #15
    
    move.b  #4, D0  *asks for input from the user
    trap    #15
    
    move.b D1, $1500 *assigns the feed amount to mem 1500
    
    lea horse_feed_amount,A1 *message for horse feed amount
    move.b  #14,D0
    trap    #15

    move.b $1500, D1 *moves the horse feed amount to D1 so that it can display it
    
    move.b #3, D0
    trap #15
   
    bsr     decorate
    rts

*-------------------------------------------------------
*--------------------Horses Inventory---------------------
* Number of horses to be allocated to a mission 
*------------------------------------------------------- 
horses:
    bsr     endl
    bsr     decorate
    
    move.b #4,$1550
    
    lea horse_amount, A1 *outputs the inputted answer
    move.b  #14,D0
    trap    #15

    move.b $1550, D1 * moves the value to D1 and displays it
    
    move.b #3, D0
    trap #15


    bsr     decorate
    rts

*-------------------------------------------------------
*-------------------Horse(s) Charge Speed---------------
* horses speed to and from a mission
*------------------------------------------------------- 
rate:
    bsr     endl
    bsr     decorate
    lea     rate_msg,A1
    move.b  #14,D0
    trap    #15
    
    move.b  #4,D0
    trap    #15
    
    move.b D1, $1510 *assigns the horse speed to mem 1510
  
    lea horse_charge_speed,A1
    move.b  #14,D0
    trap    #15
    
    move.b $1510, D1 * moves the value to D1 and displays it
    
    move.b #3, D0
    trap #15
    
    bsr     decorate
    rts

*-------------------------------------------------------
*------------------Mission Distance---------------------
* Distance to battle location
*------------------------------------------------------- 
distance:
    bsr     endl
    bsr     decorate
    lea     distance_msg,A1
    move.b  #14,D0
    trap    #15
    
    move.b  #4,D0
    trap    #15
    
    move.w D1, $1514 *assigns the distance of mission location to mem 1514
    
    lea mission_distance_question ,A1
    
    move.b #14,D0
    trap #15

    move.b  #4,D0
    trap    #15
    
    move.w D1, D2
    
    cmp #1,D1
    BEQ SELECTED_1
    BLT UNDER_1
    BGT OVER_1
    
    bsr     decorate
    rts
    
    
SELECTED_1:
    lea mission_distance ,A1
    move.b  #14,D0
    trap    #15
    
    move.w $1514, D1 * moves the value to D1 and displays it
    
    move.b #3, D0
    trap #15

    bsr     decorate
    rts
    
OVER_1:
    lea error_msg ,A1
    move.b  #14,D0
    trap    #15
    
    bsr     decorate
    bsr     distance
  

Under_1:
    bsr     decorate
    rts

*-------------------------------------------------------
*-----------------------Soldiers----------------------
* Number of soldiers
*-------------------------------------------------------   
soldiers:
    bsr     endl
    bsr     decorate
    lea     soldiers_msg,A1
    move.b  #14,D0
    trap    #15
    
    move.b  #4,D0
    trap    #15
    
    move.w D1, $1518 *assigns the soldier amount to mem 1518
    
    bsr     decorate
    rts
*-------------------------------------------------------
*---Checks the health of the player
*------------------------------------------------------- 
check_health:
    cmp #exit, A1
    beq end
    bsr decorate
    bsr gameloop

*-------------------------------------------------------
*---Game Play (Mission Progress, Battle Maneuvers)------
*------------------------------------------------------- 
gameplay:
    bsr     endl
    bsr     decorate
    lea     gameplay_msg,A1
    move.b  #14,D0
    trap    #15
    sub.b   #50, $4000
    bsr     decorate
    bsr     collision
    rts

*-------------------------------------------------------
*-----------------Heads Up Display (Score)--------------
* Retrieves the score from memory location
*-------------------------------------------------------   
hud:

    bsr     endl
    bsr     decorate
    lea     hud_msg,A1
    move.b  #14,D0
    trap    #15
    move.b  (A3),D1     retrieve the value A3 point to and move to D1
    move.b  #3,D0       move literal 3 to D0
    trap    #15         intrepret value in D0, which 3 which displays D1
    bsr     decorate
    rts

*-------------------------------------------------------
*-----------------------Taking Fire---------------------
* This could be used for collision detection, if 
*-------------------------------------------------------
collision:
    move.b  #mine_loc,D1
    cmp     #100,D1 is( x == 100)?
	bne     collision_miss if x is equal to 100, then hit
collision_hit:
    *hit
    lea     hit_msg,A1
    move    #14,D0
    trap    #15
    rts
    
collision_miss:
    *miss
    lea     miss_msg,A1
    move    #14,D0
    trap    #15
    rts

*-------------------------------------------------------
*--------------------------Loop-------------------------
*-------------------------------------------------------
loop:
    move.b  #5, D3 loop counter D3=5
next:
    lea     loop_msg,A1
    move.b  #14,D0
    trap    #15
	sub     #1,D3   decrement loop counter
    bne     next    repeat until D0=0

*-------------------------------------------------------
*------------------Screen Decoration--------------------
*-------------------------------------------------------
decorate:
    move.b  #60, D3
    bsr     endl
out:
    lea     loop_msg,A1
    move.b  #14,D0
    trap    #15
	sub     #1,D3   decrement loop counter
    bne     out	    repeat until D0=0
    bsr     endl
    rts
    
clear_screen: 
    move.b  #11,D0      clear screen
    move.w  #$ff00,D1
    trap    #15
    rts
*-------------------------------------------------------
*------------------------Replay-------------------------
*-------------------------------------------------------
replay:
    bsr     endl
    lea     replay_msg,A1
    move.b  #14,D0
    trap    #15
    
    move.b  #4,D0
    trap    #15

    cmp     #exit,D1
    beq     end         if SR Z register contains 1 beq => Branch Equals
    bsr     gameloop

endl:
    movem.l D0/A1,-(A7)
    move    #14,D0
    lea     crlf,A1
    trap    #15
    movem.l (A7)+,D0/A1
    rts
    
*-------------------------------------------------------
*-------------------Data Delarations--------------------
*-------------------------------------------------------

crlf:           dc.b    $0D,$0A,0
welcome_msg:    dc.b    '************************************************************'
                dc.b    $0D,$0A
                dc.b    'ZorkQuest: Assault on Beraith       Castle'
                dc.b    $0D,$0A
                dc.b    '************************************************************'
                dc.b    $0D,$0A,0
ask_name        dc.b    'What is your name, Mortal? ',0
accept_name     dc.b    ', Greetings, Please do enjoy the game!'
                dc.b    $0D,$0A,0
                dc.b    '',0
intro_msg       dc.b    'Once upon a time in the faraway kingdom of Ber...., is what i would say'
                dc.b    $0D,$0A
                dc.b    'if the kingdom haddent been torn down by Cthulhu, or at least the mirrage'
                dc.b    $0D,$0A
                dc.b    'of it. The seven royal knights of Beraith, each choosen because of their'
                dc.b    $0D,$0A
                dc.b    'powers and the ability to effortlsy tear down armies without budging. Oh'
                dc.b    $0D,$0A
                dc.b    'and me well i was tasked, in finding and dealing with these group of cowards,'
                dc.b    $0D,$0A
                dc.b    'by the order of '
                dc.b    $0D,$0A
                dc.b    '1. The Seraph Knights, renowned for their heavenly prowess in battle.'
                dc.b    $0D,$0A
                dc.b    '2. The Seventh Sanctum, acclaimed for their malignant nature '
                dc.b    $0D,$0A
                dc.b    'and ways in battle.'
                dc.b    $0D,$0A
                dc.b    '3. The Chocobo Knights, esteemed for their peace keeping and negotiating.'
                dc.b    $0D,$0A
                dc.b    ''
                dc.b    $0D,$0A
                dc.b    'There are four ledgendary items in Beraith, two of which i currently have'
                dc.b    $0D,$0A
                dc.b    'in my possession; The Chart of Ideals, this map has been in our family for'
                dc.b    $0D,$0A
                dc.b    'generations, i got this when my father lost his battle against the current'
                dc.b    $0D,$0A
                dc.b    'king of Beraith, The Bow of Gabriel, which is owned by the Order of the'
                dc.b    $0D,$0A
                dc.b    'Seraph Knights, The Sword of Denial, which is currently in the mits of'
                dc.b    $0D,$0A
                dc.b    'The Order of the Seventh Sanctum and lastly There is the Windweaver of'
                dc.b    $0D,$0A
                dc.b    'Serenity, which is rightfully owned by the Order of The Chocobo Knights and'
                dc.b     $0D,$0A
                dc.b    'is used in keeping peace in the lands of Beraith.'
                dc.b     $0D,$0A
                dc.b    'Choose Your Order 1:Good, 2:Evil, 3:Neutral: '
                dc.b    $0D,$0A
                dc.b    '',0
good_ch1_p1     dc.b    'When i was young, A member of The Seraph Knights, by the name of'
                dc.b    $0D,$0A
                dc.b    'Artimus appeared and saved my life from agony and despair and if death'
                dc.b    $0D,$0A
                dc.b    'is a factor to do what it takes to return the favour to Artemus and'
                dc.b    $0D,$0A
                dc.b    'become a Seraph, then my future is probally. going to be my demise.'
                dc.b    $0D,$0A
                dc.b    $0D,$0A
                dc.b    'Artemis also gifted me the Bow of Gabriel to help achive victory against'
                dc.b    $0D,$0A
                dc.b    'our Enemies. I clasped the Chart of Ideals that was stored in my satchel'
                dc.b    $0D,$0A
                dc.b    'with an elated feeling in my heart. "Show me all nearby stables" i'
                dc.b    $0D,$0A
                dc.b    'exclaimed, two beams of lights glided form the page and past my'
                dc.b    $0D,$0A
                dc.b    'face, one of which was very close to my current location i folded the map'
                dc.b    $0D,$0A
                dc.b    'and tucket it in my bag and then began walking to the stable.'
                dc.b    $0D,$0A
                dc.b    '',0
evil_ch1_p1     dc.b    'When i was younger, an innocent boy at the mere age of five, i killed both'
                dc.b    $0D,$0A
                dc.b    'my parents and my sister who was only newly born, alongside everybody else'
                dc.b    $0D,$0A
                dc.b    'in the town, who i either inncinorated or stabbed till death. About two days'
                dc.b    $0D,$0A
                dc.b    'after the incident i was approched by a man from another village who had heard'
                dc.b    $0D,$0A
                dc.b    'of the mutany. From then i was hired by this man for being a mericless killer'
                dc.b    $0D,$0A
                dc.b    'and i joined the Order of the Seventh Sanctum, i was also gifted the Sword of'
                dc.b    $0D,$0A
                dc.b    'Denail because i was one of the few worthy of weilding the weapon that was'
                dc.b    $0D,$0A
                dc.b    'sent by the Lord of Darkness. My current mission is to take out some people'
                dc.b    $0D,$0A
                dc.b    'who have been helping the King and the King himself. I dont know why and i '
                dc.b    $0D,$0A
                dc.b    'dont care i just want to finish them all. I should reach the stable in a few'
                dc.b    $0D,$0A
                dc.b    'days, where i will get some rest and transport to the castle.'
                dc.b    $0D,$0A
                dc.b    '',0
neutral_ch1_p1  dc.b    'We have always been known as The Entity or The Horde but in reality we are just'
                dc.b    $0D,$0A
                dc.b    'a group, a town, a place but no one ever seems to care when we try to explain,'
                dc.b    $0D,$0A
                dc.b    'even you, yes you, just frustratingly scrolling and reading, you probally'
                dc.b    $0D,$0A
                dc.b    'dont even relise that i am addressing you but instead think "Where is'
                dc.b    $0D,$0A
                dc.b    'this story going?". Well allow me to help you, This stroy is neither dull nor'
                dc.b    $0D,$0A
                dc.b    'drab and next time i would advise you to pick a differnt Order because,'
                dc.b    $0D,$0A
                dc.b    'we are just spectators of Beraith and pretty much everywhere else in'
                dc.b    $0D,$0A
                dc.b    'exsistance, like Earth,espically Earth, Anyway we have business to attend to,'
                dc.b    $0D,$0A
                dc.b    'so do enjoy our game and we will see you again when the plot thickens.'
                dc.b    $0D,$0A
                dc.b    'You should press 0 to restart this facinanting game.'
                dc.b    $0D,$0A
                dc.b    '',0
stable_1:       dc.b    'Its been two days and im so exhausted, but at least i arrived at the stable,'
                dc.b    $0D,$0A
                dc.b    'I noticed a strong biurly man under the tree eating an apple i approched him.'
                dc.b    $0D,$0A
                dc.b    '"Hey, Excuse me is this what you call customer service? Do you have any Horses'
                dc.b    $0D,$0A
                dc.b    'that i could buy?" i said kindve apathically and frustrated. "Yes i do as a "'
                dc.b    $0D,$0A
                dc.b    'matter of fact wait right here. Oh and next time you would want to address me'
                dc.b    $0D,$0A
                dc.b    'properly if you wnat to keep that head of yours." he gloated like a little '
                dc.b    $0D,$0A
                dc.b    'child in a playground. About ten minutes later he came back and asked me'
                dc.b    $0D,$0A
                dc.b    '"How much horse feed would you like with the horse id say to get to castle'
                dc.b    $0D,$0A
                dc.b    'Beraith you would need at least 50" he smiled gleefully almost as if he was'
                dc.b    $0D,$0A
                dc.b    'delighted to see a person."Oh and feed costs 1 gold each so you would need 100'
                dc.b    $0D,$0A
                dc.b    'gold for 100 pieces. Im sure you could handle that young fellow!" he'
                dc.b    $0D,$0A
                dc.b    'said hasily.'
                dc.b    $0D,$0A
                dc.b    '',0
feed_amount     dc.b    'How Much Feed Would You Like to take?',0
gold_amount     dc.b    'Current Gold: ',0
stable_buy      dc.b    'You Recieved a huge stalion with massive amounts of Stamina and ',0
feed_current    dc.b    'You have ',0
stable_wrong    dc.b    '"Im sorry but i cant send you on a death mission, you will never '
                dc.b    $0D,$0A
                dc.b    'reach the castle with that amount of feed. Please take more than fifty"'
                dc.b    $0D,$0A
                dc.b    'the stable hand said unhappily.'
                dc.b    $0D,$0A
                dc.b    '',0
word_feed       dc.b    ' feed.'
                dc.b    $0D,$0A
                dc.b    '',0
stable_end      dc.b    ''
                dc.b    $0D,$0A
                dc.b    '"Thank you for your purchase, I really appreciate the business from people'
                dc.b    $0D,$0A
                dc.b    'such as yourself", the stable hand additmited shyly. I turned almost to'
                dc.b    $0D,$0A
                dc.b    'fior the stable hand to even comprehend what was happening. I jumped on '
                dc.b    $0D,$0A
                dc.b    'back of the horse and put the feed in the satchel that was attached to the'
                dc.b    $0D,$0A
                dc.b    'horses side.'
                dc.b    $0D,$0A
                dc.b    '',0
departure_msg   dc.b    'Would you like to leave the stable? 1:Yes, 2:No'
                dc.b    $0D,$0A
                dc.b    '',0
Evil_ch1_p2     dc.b    'After about two days i reached the exterior of the castle to only be'
                dc.b    $0D,$0A
                dc.b    'confronted by big walls that streched far around the kingdom, but '
                dc.b    $0D,$0A
                dc.b    'fortunatly i knew how to conquer this wall thanks to my client that'
                dc.b    $0D,$0A
                dc.b    'provided me with the plans to the castle, because my top priority is to'
                dc.b    $0D,$0A
                dc.b    'get the kings head then im free to do what i wish, which is slaugher'
                dc.b    $0D,$0A
                dc.b    'whomever i can find. I crouch and dash towards the drains of the castle'
                dc.b    $0D,$0A
                dc.b    'while glancing about the perimeter of the walls to make sure no mugs see'
                dc.b    $0D,$0A
                dc.b    'me. I use my skeleton key to open the drain and i pull and pull but'
                dc.b    $0D,$0A
                dc.b    'nothing, it seems to be weilded shut for the inside. I could cut it with'
                dc.b    $0D,$0A
                dc.b    'my sword of Denial but it will make a lot of noise. Ah well cant be '
                dc.b    $0D,$0A
                dc.b    'helped and maybe i might have some fun before i get to the king. "Btoom"'
                dc.b    $0D,$0A
                dc.b    'the drain lid fell to the ground with a massive clatter. "Hey what was that?".'
                dc.b    $0D,$0A
                dc.b    'I slipped away into the tunnelAnd up to the richer parts of the Kingdom, then'
                dc.b    $0D,$0A
                dc.b    'the kings entrance hall, then finally after thirty minutes i reached the kings'
                dc.b    $0D,$0A
                dc.b    'room. I climed through the urinal and changed from my stinking clothes into'
                dc.b    $0D,$0A
                dc.b    'the kings own gown. "AHAHAHAHAHAHHAHAHA", i exclaimed. "Finally after all that'
                dc.b    $0D,$0A
                dc.b    'time now i get to play, its been to long". I grabbed my sword and made a.'
                dc.b    $0D,$0A
                dc.b    'slit in the side of the kings matress. I then made my way into the '
                dc.b    $0D,$0A
                dc.b    'matress and covered it up with his flannels, hoping he wouldnt see it '
                dc.b    $0D,$0A
                dc.b    'i made my move tonight.'
                dc.b    $0D,$0A
                dc.b    '',0
Good_ch1_p2     dc.b    'After a few days i found the inconspicuously, hidden castle in the'
                dc.b    $0D,$0A
                dc.b    'eastern part of the continent. Unfortunatly i dont have any plan'
                dc.b    $0D,$0A
                dc.b    'except tring to infiltrate the walls. I rode across the bridge and'
                dc.b    $0D,$0A
                dc.b    'hoped off my horse. "State your intentions for visting?" exclaimed'
                dc.b    $0D,$0A
                dc.b    'a guard that was hidden behind the big wooden door of the fortress.'
                dc.b    $0D,$0A
                dc.b    '"Hey i was just a little lost and i figured it was kinda late so'
                dc.b    $0D,$0A
                dc.b    'i was looking for an inn and some babes to chill with tonight'
                dc.b    $0D,$0A
                dc.b    'is there any such establishment here", i hollered. "I got you'
                dc.b    $0D,$0A
                dc.b    'im coming down now".The door clunked open and there was a tall guard'
                dc.b    $0D,$0A
                dc.b    'standing with the utmost cockiness. "So this establishment is up '
                dc.b    $0D,$0A
                dc.b    'in the rich district and you might see the king there he seems to'
                dc.b    $0D,$0A
                dc.b    'be there alot lately.". I thanked him and quikly hurried up to '
                dc.b    $0D,$0A
                dc.b    'upper most district to get ready for the assaination of the king.'
                dc.b    $0D,$0A
                dc.b    'I open the door to the bar and walked over to the counter. I '
                dc.b    $0D,$0A
                dc.b    'decided this was the best place to be in case i misse dhim arriving.'
                dc.b    $0D,$0A
                dc.b    'I am all ready for the king and his goons now.'
                dc.b    $0D,$0A
                dc.b    '',0
epilouge_1      dc.b    'Its us again, The Entity, The horde, of course you wouldnt know who'
                dc.b    $0D,$0A
                dc.b    'we are unless you truly played this game, but for those of you who'
                dc.b    $0D,$0A
                dc.b    'did heres a few riddles for you and if you get these riddles right'
                dc.b    $0D,$0A
                dc.b    'you might just be allowed to leave.'
                dc.b    $0D,$0A
                dc.b    '',0
riddle_1        dc.b    'How much dirt is there in a hole that is 3 ft deep, and 9 inches in diameter?'
                dc.b    $0D,$0A
                dc.b    '9 inches in diameter?'
                dc.b    $0D,$0A
                dc.b    '',0
riddle_2        dc.b    'My age today is three times what it will be three years from now'
                dc.b    $0D,$0A
                dc.b    'minus three times what my age was three years ago. How old am I?'
                dc.b    $0D,$0A
                dc.b    '',0
riddle_3        dc.b    ' has 4 daughters. Each of his daughters has a brother.'
                dc.b    $0D,$0A
                dc.b    'How many children does Mr. Smith have?'
                dc.b    $0D,$0A
                dc.b    '',0
ending          dc.b    ' well done. Not many People would get this far without looking up the answer'
                dc.b    $0D,$0A
                dc.b    'unless you did look up the answer if thats the case you should be ashamed '
                dc.b    $0D,$0A
                dc.b    'of yourself for stopping that low. Regardless Though WELL DONE!!!'
                dc.b    $0D,$0A
                dc.b    'YOU JUST COMPLETED THE GAME< HOP YOU ENJOYED!!!!!!'
                dc.b    $0D,$0A
                dc.b    '',0
replay_msg:     dc.b    'Press 0 to quit, Press anything else to replay'
                dc.b    $0D,$0A
                dc.b    '',0
*---------------------------------------------------------------------------------------------------------------------------------------
feed_msg:       dc.b    'Feed load (each horse needs at least 100 units of feed)'
                dc.b    $0D,$0A
                dc.b    'Enter feed load : ',0
horses_msg:     dc.b    'Number of horses : ',0
rate_msg:       dc.b    'One Third[1], Two Thirds[2], Standard Charge[3], ' 
                dc.b    $0D,$0A
                dc.b    'Full Charge[4], Flank Charge[5] units feed per click'
                dc.b    $0D,$0A
                dc.b    'Enter Speed : ',0
distance_msg:   dc.b    'Mission distance e.g. 40 (with 100 units of feed  '
                dc.b    $0D,$0A
                dc.b    'One Third speed 20 units remain for manuvouirs) horses '
                dc.b    $0D,$0A
                dc.b    'Horses without feed are lost.'
                dc.b    $0D,$0A
                dc.b    'Enter mission distance : ',0
soldiers_msg:   dc.b    'Each horses need at least 1 Knight and an Stable Hand'
                dc.b    $0D,$0A
                dc.b    'minimum requirement is 2 i.e. Stable Hand x 1 and Knight x 1.'
                dc.b    $0D,$0A
                dc.b    'Enter # of soldiers : ',0
gameplay_msg:   dc.b    'Add Gameplay !',0
update_msg:     dc.b    'Update Gameplay !',0
draw_msg:       dc.b    'Draw Screen !',0
hit_msg:        dc.b    'Strike!',0
miss_msg:       dc.b    'Miss!',0
loop_msg:       dc.b    '.',0

hud_msg:        dc.b    'Your Score Is: ',0
horse_feed_amount dc.b  'The Horse Feed Amount you have selected is: ',0
horse_charge_speed dc.b 'The Charge Speed you have selcted is: ',0
horse_amount    dc.b    'Amount Of Horses is: ',0
mission_distance dc.b   'The mission distance is: ',0
mission_distance_question dc.b   'Press 1 to view distance to mission, Press 0 to continue ',0
error_msg   dc.b 'Inputted Wrong Number',0


health:     ds.w    1
score:      ds.w    1 reserve space for score

    end start




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
