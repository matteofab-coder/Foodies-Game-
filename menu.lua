






local composer = require("composer")

local scene = composer.newScene()


display.setStatusBar(display.HiddenStatusBar)




  -- SCENA CREATE --


function scene:create(event)

local currentTrack

local sceneGroup = self.view

local suonoTasto = audio.loadSound("water-drop-plop.mp3")

local volume = 0




local background = display.newImageRect("immagini/kitchen.jpg",400,720)
background.x = display.contentCenterX
background.y = display.contentCenterY + 25            -- sfondo menù
background:toBack()
sceneGroup:insert(background)

local overlay = display.newRect(display.contentCenterX, display.contentCenterY, 768, 1344)
overlay:setFillColor(0, 0, 0)
overlay.alpha = 0.65                              -- ho applicato un rettangolo nero per scurire un po' lo sfondo
sceneGroup:insert(overlay)

local titolo = display.newImageRect("immagini/titolo.png",330,205)
titolo.x = display.contentCenterX
titolo.y = 80                                               -- titolo del gioco
sceneGroup:insert(titolo)


local pulsante = display.newImageRect("immagini/play.png",90,60)
pulsante.x = display.contentCenterX                          -- pulsante Play normale che rimanda al livello del gioco
pulsante.y = display.contentCenterY + 60
sceneGroup:insert(pulsante)


local playButton = display.newImageRect("immagini/playPressed.png",90,60)
playButton.x = display.contentCenterX
playButton.y = display.contentCenterY + 60              --pulsante Play premuto per animazione pulsante
playButton.isVisible = false
sceneGroup:insert(playButton)


local options = display.newImageRect("immagini/options.png",90,60)
options.x = display.contentCenterX
options.y = display.contentCenterY + 160
sceneGroup:insert(options)                               -- pulsante Options normale per aprire le impostazioni


local optionsPressed = display.newImageRect("immagini/optionsPressed.png",90,60)
optionsPressed.x = display.contentCenterX
optionsPressed.y = display.contentCenterY + 160             -- pulsante Options premuto per animazione di click
optionsPressed.isVisible = false
sceneGroup:insert(optionsPressed)



local interface = display.newImageRect("immagini/sfondoUI.png",300,280)
interface.x = display.contentCenterX + 330                       -- sfondo impostazioni
interface.y = display.contentCenterY + 80
sceneGroup:insert(interface)
interface:toFront()



local volumeIcon = display.newImageRect("iconaVolume.png",50,50)
volumeIcon.x = interface.x
volumeIcon.y = display.contentCenterY - 10
sceneGroup:insert(volumeIcon)



local sliderBar = display.newImageRect("immagini/sliderBar.png",250,30)
sliderBar.x = interface.x 
sliderBar.y = display.contentCenterY + 105
sceneGroup:insert(sliderBar)                       -- Barretta su cui scorre il cursore del volume

local sliderButton = display.newImageRect("immagini/bottoneVolume.png",40,40)
sliderButton.x = interface.x - 110
sliderButton.y = display.contentCenterY + 105
sceneGroup:insert(sliderButton)                     -- cursore del volume


local backButton = display.newImageRect("immagini/back.png",90,60)
backButton.x = interface.x
backButton.y = interface.y + 90
sceneGroup:insert(backButton)                      -- tasto per chiudere le impostazioni



local backButtonPressed = display.newImageRect("immagini/backPressed.png",90,60)
backButtonPressed.x = interface.x
backButtonPressed.y = interface.y + 90
backButtonPressed.isVisible = false
sceneGroup:insert(backButtonPressed)                 -- tasto premuto per chiudere le impostazioni



local volumeUp = display.newImageRect("iconaPiu.png",30,30)
volumeUp.x = display.contentCenterX + 420
volumeUp.y = display.contentCenterY + 50
volumeUp:rotate(45)
sceneGroup:insert(volumeUp)

local volumeDown = display.newImageRect("iconaMeno.png",30,7)
volumeDown.x = display.contentCenterX + 240
volumeDown.y = display.contentCenterY + 50
sceneGroup:insert(volumeDown)



local function schiacciaBottone(event)
    if event.phase == "began" then

         pulsante.isVisible = false

         playButton.isVisible = true                             --funzione che, in caso di click sul pulsante, sostituisce
                                                                  --  l'immagine premuta all'immagine standard del pulsante, creando
         audio.play(suonoTasto)                                   -- l'effetto di pressione e chiamando il composer che rimuove la scena e passa a "livello"
     
    elseif (event.phase == "ended" or event.phase == "cancelled") then 
      

         pulsante.isVisible = true

         playButton.isVisible = false

        composer.removeScene("menu")
        composer.gotoScene("livello")
        
        audio.stop()
         
    end
    return true
end

pulsante:addEventListener("touch",schiacciaBottone)
playButton:addEventListener("touch", schiacciaBottone)




local function schiacciaOptions(event)

    if event.phase == "began" then 

        options.isVisible = false

        optionsPressed.isVisible = true

        audio.play(suonoTasto)

    elseif (event.phase == "ended" or event.phase == "cancelled") then            --stessa funzione di prima ma questa al rilascio del pulsante attiva le transizioni
                                                                                   -- "aprendo" le impostazioni
        options.isVisible = true

        optionsPressed.isVisible = false

        transition.to(interface, {x = display.contentCenterX, y = display.contentCenterY + 80 , time = 500})
        transition.to(volumeIcon,{x = display.contentCenterX, y = display.contentCenterY - 10, time = 500})
        
        transition.to(backButton, {x = display.contentCenterX, y = display.contentCenterY + 170, time = 500})
        transition.to(backButtonPressed, {x = display.contentCenterX, y = display.contentCenterY + 170, time = 500})
        
        transition.to(sliderBar, {x = display.contentCenterX, y = display.contentCenterY + 105, time = 500})
        transition.to(sliderButton, {x = display.contentCenterX - 110, y = display.contentCenterY + 105, time = 500})

        transition.to(volumeUp, {x = display.contentCenterX + 90, y = display.contentCenterY + 50, time = 500})
        transition.to(volumeDown, {x = display.contentCenterX - 90, y = display.contentCenterY + 50, time = 500})



    end
    return true
end

options:addEventListener("touch",schiacciaOptions)
optionsPressed:addEventListener("touch",schiacciaOptions)






local function schiacciaBack(event)

    if event.phase == "began" then
        
        backButton.isVisible = false
        backButtonPressed.isVisible = true

        audio.play(suonoTasto)

    elseif (event.phase == "ended" or event.phase =="cancelled") then

        backButton.isVisible = true
        backButtonPressed.isVisible = false 

    transition.to(interface, {x = display.contentCenterX + 330, y = display.contentCenterY + 80 , time = 500})
    transition.to(volumeIcon,{x = display.contentCenterX + 330, y = display.contentCenterY - 10, time = 500})                 --stessa funzione di prima, con animazione pulsante Back, per "chiudere"
                                                                                                                              -- le impostazioni

    transition.to(backButton, {x = display.contentCenterX + 330, y = display.contentCenterY + 170, time = 500})
    transition.to(backButtonPressed, {x = display.contentCenterX + 330, y = display.contentCenterY + 170, time = 500})


    transition.to(sliderBar, {x = display.contentCenterX + 330, y = display.contentCenterY + 105, time = 500})
    transition.to(sliderButton, {x = display.contentCenterX + 225, y = display.contentCenterY + 105, time = 500})

    transition.to(volumeUp, {x = display.contentCenterX + 420, y = display.contentCenterY + 50, time = 500})
    transition.to(volumeDown, {x = display.contentCenterX + 240, y = display.contentCenterY + 50, time = 500})



    end
   return true
end

backButton:addEventListener("touch",schiacciaBack)
backButtonPressed:addEventListener("touch", schiacciaBack)



local function gestisciVolume(event)                        -- funzione che gestisce il selettore del volume tramite una barretta e un cursore da trascinare

   if (event.phase == "began" or event.phase == "moved") then

    local x = math.max(sliderBar.x - sliderBar.width / 2, math.min(event.x, sliderBar.x + sliderBar.width / 2))    -- limiti del movimento sulla barra

    sliderButton.x = x      -- aggiorna posizione cursore sulla barra

    volume = (x - (sliderBar.x - sliderBar.width / 2)) /sliderBar.width    --calcola volume in base alla posizione x del cursore

    audio.setVolume(volume)   --imposta volume audio

   end
end

sliderButton:addEventListener("touch", gestisciVolume)










-- AUDIO MENU --











local audioFiles = {
         
         audio.loadStream("musiche/Luna.mp3");
         audio.loadStream("musiche/mambo italiano.mp3");
         audio.loadStream("musiche/that's amore.mp3");           -- variabile array per le 3 musiche che vengono scelte pseudo casualmente nel menù
         
      }










local function playAudio() 

         local indiceRandom = math.random(1,#audioFiles);             --funzione che "sceglie" la musica da riprodurre  definendo un indice random
                                                                       -- dall'indice 1 alla lunghezza di #audioFiles per poi riprodurre la musica in currentTrack
         local traccia = audioFiles[indiceRandom];

         local currentTrack

          currentTrack = audio.play(traccia, {loops = -1})
          audio.setVolume(0.1)

           return currentTrack
      end

playAudio()
end


       --  FUNZIONE DESTROY --

function scene:destroy(event)              -- funzione che "distrugge" la scena eliminando dalla memoria tutti gli 
                                             -- oggetti grafici e gli ascoltatori definiti dentro essa

    local sceneGroup = self.view

    print("destroy chiamata")


    if pulsante then
        pulsante:removeEventListener("touch",schiacciaBottone)
        display.remove(pulsante)
        pulsante = nil
    end

    if playButton then
        playButton:removeEventListener("touch",schiacciaBottone)
        display.remove(playButton)
        playButton = nil
    end

    if background then
        display.remove(background)
        background = nil
    end

    if overlay then
        display.remove(overlay)
        overlay = nil
    end

    if titolo then
        display.remove(titolo)
        titolo = nil
    end
    
    if options then
        options:removeEventListener("touch",schiacciaOptions)
        display.remove(options)
        options = nil
    end

    if optionsPressed then
        optionsPressed:removeEventListener("touch",schiacciaOptions)
        display.remove(optionsPressed)
        optionsPressed = nil
    end

    if volumeText then
        display.remove(volumeText)
        volumeText = nil
    end

    if volumeText2 then
        display.remove(volumeText2)
        volumeText2 = nil
    end

    if buttonText then
        display.remove(buttonText)
        buttonText = nil
    end

    if interface then
        display.remove(interface)
        interface = nil
    end
    
    if backButton then
        backButton:removeEventListener("touch",schiacciaBack)
        display.remove(backButton)
        backButton = nil
    end

    if backButtonPressed then
        backButtonPressed:removeEventListener("touch",schiacciaBack)
        display.remove(backButtonPressed)
        backButtonPressed = nil
    end

    if sliderBar then
        display.remove(sliderBar)
        sliderBar = nil
    end

    if sliderButton then
        sliderButton:removeEventListener("touch",gestisciVolume)
        display.remove(sliderButton)
        sliderButton = nil
    end

    if currentTrack then 
        audio.stop(currentTrack)
        currentTrack = nil
    end

    if volumeDown then
        display.remove(volumeDown)
        volumeDown = nil
    end

    if volumeUp then
        display.remove(volumeUp)
        volumeUp = nil
    end

end

  scene:addEventListener("create",scene)             --ascoltatori che richiamano "create" e "destroy"
  scene:addEventListener("destroy",scene)

  return scene