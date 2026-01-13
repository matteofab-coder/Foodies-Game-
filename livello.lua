




local composer = require("composer")
                                          -- richiamo la libreria del composer per gestire la scena
local scene = composer.newScene()





--Array di immagini scelte randomicamente per lo sfondo a ogni avvio del livello

local backgroundImages = {
    {file = "immagini/sfondoCucina.jpg", width = 900, height = 750, x = display.contentCenterX - 70, y = display.contentCenterY},
    {file = "immagini/sfondoCucina2.jpg", width = 900, height =750, x = 330, y = display.contentCenterY},
    {file = "immagini/kitchen.jpg", width = 400, height = 720, x = display.contentCenterX, y = display.contentCenterY + 25},
    {file = "immagini/sfondoCucina4.jpg", width = 900, height = 750, x = display.contentCenterX, y = display.contentCenterY}
 }


  local function immagineRandom(sceneGroup)

       local randomIndice = math.random(1,#backgroundImages)

       local imageInfo = backgroundImages[randomIndice]

       local immagineSfondo = display.newImageRect(imageInfo.file, imageInfo.width, imageInfo.height)
       immagineSfondo.x = imageInfo.x
       immagineSfondo.y = imageInfo.y 
       immagineSfondo:toBack()

   end








         -- FUNZIONE SCENE:CREATE() --

function scene:create(event)

    local sceneGroup = self.view

    --SFONDO--

display.setStatusBar(display.HiddenStatusBar)    -- Nascondo la barretta superiore del dispositivo


local checkBoxBackground = display.newRect(40,-70,60,60)     -- sfondo per l'oggetto "premio" --
checkBoxBackground:setFillColor(0,255,0)
sceneGroup:insert(checkBoxBackground)

local checkBox = display.newImageRect("glow_frame.png",80,80)      -- contorno per il frutto "obiettivo" --
checkBox.x = 40
checkBox.y = -70
sceneGroup:insert(checkBox)





end



--   FUNZIONE SCENE:SHOW() --



function scene:show(event)
    local sceneGroup = self.view

    local phase = event.phase

 if (phase == "will") then



    elseif (phase == "did") then
        

       immagineRandom(sceneGroup)


      local physics = require("physics");
       physics.start();
       physics.setDrawMode("normal")


-- LIMITI LATI --


      local limiteDestro = display.newRect(display.contentWidth + 30, display.contentCenterY,60,750)
      physics.addBody(limiteDestro,"static", {density = 3})
      sceneGroup:insert(limiteDestro)                        -- rettangoli per assicurarsi ulteriormente che il cibo o il cestino non fuoriescano

      local limiteSinistro = display.newRect(-30,display.contentCenterY,60,750)
      physics.addBody(limiteSinistro,"static", {density = 3})
      sceneGroup:insert(limiteSinistro)


    -- CIBO CHE CADE --


local foodImages = { "immagini/cibi/bacon.png", "immagini/cibi/burger.png", "immagini/cibi/burrito.png", 
                     "immagini/cibi/cheesecake.png", "immagini/cibi/chocolatecake.png", "immagini/cibi/cookie.png",
                     "immagini/cibi/donut.png", "immagini/cibi/friedegg.png",
                     "immagini/cibi/hotdog.png", "immagini/cibi/icecream.png", "immagini/cibi/lemonpie.png",          -- array immagini cibi
                     "immagini/cibi/steak.png",  "immagini/cibi/taco.png"}


local correctFood       -- cibo giusto da raccogliere (cambia ogni volta)

local totalFood = 119    -- cibi totali

local correctFruit = 0           --numero di cibi corretti già presi nel cestino

local spawnedFood = 0            --cibi spawnati

local correctFoodDisplay  -- oggetto in alto a sinistra

local correctSpawnedFruit = 0    -- frutti corretti spawnati (per counter delle stelle ricompense)

--local correctObject    -- variabile prova

local percentage        --percentuale per calcolo delle stelline "premio"

















--CESTINO E SUA FISICA --



local immaginiCestino = {}


local cestinoLato = display.newRect(display.contentCenterX - 40,display.contentHeight - 47,5,65);
cestinoLato:setFillColor(0,0,255);
physics.addBody(cestinoLato);
cestinoLato.isVisible = false
cestinoLato.gravityScale = 4
sceneGroup:insert(cestinoLato)           -- lato sinistro del cestino per le collisioni oggetti


local cestinoLato2 = display.newRect(display.contentCenterX + 40, display.contentHeight - 47,5,65);
cestinoLato2:setFillColor(0,0,255);
physics.addBody(cestinoLato2);
cestinoLato2.isVisible = false
cestinoLato2.gravityScale = 4
sceneGroup:insert(cestinoLato2)             -- lato destro cestino per collisioni oggetti

local cestinoFondo = display.newRect(display.contentCenterX,display.contentHeight - 17,84,5);
cestinoFondo:setFillColor(0,0,255);
physics.addBody(cestinoFondo);
cestinoFondo.isVisible = false
cestinoFondo.gravityScale = 4
sceneGroup:insert(cestinoFondo)             --fondo del cestino per collisioni oggetti


local sfondoCestino = display.newImageRect("immagini/cesto.png",130,90);
sfondoCestino.x = display.contentCenterX;
sfondoCestino.y = display.contentHeight - 50;
physics.addBody(sfondoCestino, "dynamic", {isSensor = true});
sfondoCestino.gravityScale = 4
sceneGroup:insert(sfondoCestino)                     -- immagine del cestino 

local sensore = display.newRect(display.contentCenterX, display.contentHeight - 35, 56, 30)
sensore:setFillColor(0, 0, 255)  -- Colore blu
sensore.isVisible = false
physics.addBody(sensore, "dynamic", {isSensor = true})
sensore.gravityScale = 4
sceneGroup:insert(sensore)       -- rettangolino che funge da sensore per l'evento di collisione che 
                                  -- attiva la funzione di raccolta oggetti






-- GIUNTI CESTINO --

physics.newJoint("weld",cestinoLato,sfondoCestino,2.5,20)
physics.newJoint("weld",cestinoLato2,sfondoCestino,2.5,20)          -- giunti fisici che "saldano" il cestino insieme
physics.newJoint("weld",cestinoFondo,sfondoCestino,44,2.5)
physics.newJoint("weld",sensore,sfondoCestino,33,15)




--CONTROLLO TOCCO DENTRO IMMAGINE--



local function isTouchInside(target,event)
    
  if target == nil then return true end

    local bounds = target.contentBounds
    local x,y = event.x, event.y
    return (x >= bounds.xMin and x <= bounds.xMax and y >= bounds.yMin and y <= bounds.yMax)  -- controllo che il tocco "o mouse" avvenga dentro i limiti del cestino
end



local dragging = false        -- variabile per controllare se cestino si muove
local touchJoint  = nil   
local targetObject = nil     





-- MOVIMENTO MOUSE --

local function movimentoMouse (event)

   local target = event.target

    local touchX = event.x;
    local touchY = event.y;


     if event.phase == "began" and isTouchInside(sfondoCestino,event) then
         targetObject = sfondoCestino 

           if  not touchJoint then 
              touchJoint = physics.newJoint("touch", sfondoCestino,touchX,touchY);          -- funzione che permette al mouse (o tocco) di muovere
              touchJoint.maxForce = 1000                                                    -- il cestino sullo schermo

           end
         touchJoint:setTarget(touchX,touchY);
   
     elseif event.phase == "moved"and targetObject then
           if touchJoint  then
               touchJoint:setTarget(touchX,touchY)
           end

     elseif (event.phase == "ended" or event.phase == "cancelled") and targetObject then
        
           if touchJoint then
                touchJoint:removeSelf()
                touchJoint = nil
            end
        targetObject = nil

end
    return true;

end


Runtime:addEventListener("touch",movimentoMouse) 






--CONTROLLO USCITA CESTINO DA SCHERMO INFERIORE E LATERALI --

 local function tornaIndrio(event)
  
  if sfondoCestino.y == nil then return end

    if sfondoCestino.y >= display.contentHeight + 80  then
        sfondoCestino.y = display.contentHeight + 80              --funzione che non permette al cestino di "cadere" al di fuori dello schermo

    elseif 
           sfondoCestino.x >= display.contentWidth  then
           sfondoCestino.x = display.contentWidth
    elseif
        sfondoCestino.x <= 0 then
        sfondoCestino.x = 0

    end

end


Runtime:addEventListener("enterFrame",tornaIndrio)




-- SPAWN E CADUTA DEL CIBO --

 
   
local function chooseCorrectFood()
    local randomIndex = math.random(1, #foodImages)
    correctFood = foodImages[randomIndex] 
   
    if correctFoodDisplay then
        correctFoodDisplay:removeSelf()                            --funzione che sceglie randomicamente tra l'array del cibo il cibo "obiettivo"
        correctFoodDisplay = nil
    end


    correctFoodDisplay = display.newImageRect(correctFood, 50, 50)
    correctFoodDisplay.x = 40 -- Posizione x (sinistra)
    correctFoodDisplay.y = -70 -- Posizione y (alto)  
    sceneGroup:insert(correctFoodDisplay)
    
end






-- PREMIO FINE LIVELLO --


local prizeInterface = display.newImageRect("immagini/sfondoUI.png",300,400)
prizeInterface.x = -150
prizeInterface.y = -150                                                       --sfondo dell'interfaccia di fine livello
sceneGroup:insert(prizeInterface)



local sfondoStella = display.newImageRect("immagini/sfondoStella.png",50,50)
sfondoStella.x = -150
sfondoStella.y = -150                                                        -- slot stellina "scura" dove andranno le stelle premio se ottenute
sceneGroup:insert(sfondoStella)


local sfondoStella2 = display.newImageRect("immagini/sfondoStella.png",50,50)
sfondoStella2.x = -150
sfondoStella2.y = -150
sceneGroup:insert(sfondoStella2)


local sfondoStella3 = display.newImageRect("immagini/sfondoStella.png",50,50)
sfondoStella3.x = -150
sfondoStella3.y = -150
sceneGroup:insert(sfondoStella3)


local sfondoStella4 = display.newImageRect("immagini/sfondoStella.png",50,50)
sfondoStella4.x = -150
sfondoStella4.y = -150
sceneGroup:insert(sfondoStella4)



local stellina1 = display.newImageRect("immagini/stellina.png", 50,50)
stellina1.x = display.contentCenterX - 50
stellina1.y = -150                                    --stelle premio che vengono ottenute in base alla percentuale
sceneGroup:insert(stellina1)


local stellina2 = display.newImageRect("immagini/stellina.png", 50,50)
stellina2.x = display.contentCenterX - 50
stellina2.y = -150
sceneGroup:insert(stellina2)


local stellina3 = display.newImageRect("immagini/stellina.png", 50,50)
stellina3.x = display.contentCenterX - 50
stellina3.y = -150
sceneGroup:insert(stellina3)


local stellina4 = display.newImageRect("immagini/stellina.png", 50,50)
stellina4.x = display.contentCenterX - 50
stellina4.y = -150
sceneGroup:insert(stellina4)


local marioStar = display.newImageRect("immagini/marioStar.png",90,90)
marioStar.x = display.contentCenterX                                         -- "super stella" ottenuta solo in caso di 100%
marioStar.y = display.contentCenterY - 500
sceneGroup:insert(marioStar)





-- CANZONE / SUONI SOTTOFONDO --

local backgroundMusic = audio.loadStream("musiche/videoplayback.m4a", {loops = -1})

audio.play(backgroundMusic)
audio.setVolume(0.05)

local foodSound = audio.loadSound("collectFood.wav")

local wompWomp = audio.loadSound("wompWomp.mp3")

local yeee = audio.loadSound("Yay.mp3")


local dbsong = audio.loadSound("dragonBall.mp3")


local weakClap = audio.loadSound("weakClapping.mp3")

local notBad = audio.loadSound("notBad.mp3")




local function prizeMoney()        --funzione che assegna il premio in base alla percentuale

  percentage = (correctFruit / correctSpawnedFruit) * 100   --percentuale 

  

     transition.to(prizeInterface, {time = 1000, x = display.contentCenterX, y = display.contentCenterY,
                                     rotation = 360})
     transition.to(sfondoStella, {x = display.contentCenterX -95, y = display.contentCenterY -60,
                                      rotation = 360, 
                                      time = 500, delay = 1100})
     transition.to(sfondoStella2, {x = display.contentCenterX - 35, y = display.contentCenterY - 100,                 -- transizioni animazione alla fine del livello prima delle stelle premio
                                      rotation = 360, time = 500, delay = 1100})
     transition.to(sfondoStella3, {x = display.contentCenterX + 35, y = display.contentCenterY - 100,
                                      rotation = 360, time = 500, delay = 1100})
     transition.to(sfondoStella4, {x = display.contentCenterX + 95, y = display.contentCenterY -60,
                                      rotation = 360, time = 500, delay = 1100})

     
     audio.pause(backgroundMusic)

     if correctFruit >= 1 then

     local numeroCounter = display.newText({text = string.format("cibi raccolti = "..correctFruit), x = display.contentCenterX,
                                            y = display.contentCenterY + 130, font = "Comic Sans MS",
                                             fontSize = 30})
     numeroCounter:setFillColor(1,1,0)
      
     end

     

    if percentage == 100 then                       -- transizioni e suoni per 100%
        
        transition.to(stellina1, {x = display.contentCenterX -95, y = display.contentCenterY -60,
                                      rotation = 360, 
                                      time = 700, delay = 1400})

        transition.to (stellina2, {x = display.contentCenterX - 35, y = display.contentCenterY - 100,
                                      rotation = 360, time = 700, delay = 1400})
        

        transition.to(stellina3, {x = display.contentCenterX + 35, y = display.contentCenterY - 100,
                                      rotation = 360, time = 700, delay = 1400})

        transition.to(stellina4, {x = display.contentCenterX + 95, y = display.contentCenterY -60,
                                      rotation = 360, time = 700, delay = 1400})

        transition.to(marioStar, {x = display.contentCenterX, y = display.contentCenterY + 40, rotation = 360, time = 700, delay = 400})

        audio.play(dbsong)


    
    elseif percentage >= 75 then         -- transizioni e suoni per 75%

        transition.to(stellina1, {x = display.contentCenterX -95, y = display.contentCenterY -60,
                                      rotation = 360, 
                                      time = 700, delay = 1400})

        transition.to (stellina2, {x = display.contentCenterX - 35, y = display.contentCenterY - 100,
                                      rotation = 360, time = 700, delay = 1400})


        transition.to(stellina3, {x = display.contentCenterX + 35, y = display.contentCenterY - 100,
                                      rotation = 360, time = 700, delay = 1400})

    audio.play(yeee)

    elseif percentage >= 50 then         -- transizioni e suoni per 50%

        transition.to(stellina1, {x = display.contentCenterX -95, y = display.contentCenterY -60,
                                      rotation = 360, 
                                      time = 700, delay = 1400})

        transition.to (stellina2, {x = display.contentCenterX - 35, y = display.contentCenterY - 100,
                                      rotation = 360, time = 700, delay = 1400})
    
    audio.play(notBad)

    elseif percentage >= 25 then             -- transizioni e suoni per 25%
         transition.to(stellina1, {x = display.contentCenterX -95, y = display.contentCenterY -60,
                                      rotation = 360, 
                                      time = 700, delay = 1400})
    
    audio.play(weakClap)

    elseif percentage < 25  or (correctSpawnedFruit == 0 and percentage < 25) then
          
          audio.play(wompWomp)
    end
end







-- SPAWN CIBO --                 -- funzione che spawna il cibo dall'alto randomicamente rispetto all'asse X

local function spawnFood()

   spawnedFood = spawnedFood + 1
   print("frutti spawnati = "..spawnedFood)


    local randomIndex = math.random(1, #foodImages)
      
    local food = display.newImageRect(foodImages[randomIndex], 60, 60)

          food.x = math.random(50, display.contentWidth - 50)  -- PosX cibo casuale
          food.y = -150
          food.name = foodImages[randomIndex] 
          physics.addBody(food, "dynamic", {radius = 20}) 
          food.gravityScale = math.random(2,3.6)
                                               -- Aggiunge fisica dinamica per far cadere il frutto
    
   
          if food.name == correctFood then
            correctSpawnedFruit = correctSpawnedFruit + 1
            print("frutti corretti spawnati = " ..correctSpawnedFruit)
          end

        local function removeFood(event)
               if food and food.y ~= nil and food.y >= display.contentHeight + 120 then 
                   Runtime:removeEventListener("enterFrame",food)
                                                                                                 -- una volta che il cibo passa una certa soglia sull'asse Y, viene rimosso
                   food:removeSelf()
                   food = nil

                end
        end


        if spawnedFood == totalFood then     -- chiamata alla funzione "premio" alla fine del livello
            timer.performWithDelay(7000,prizeMoney,1)


        end


   Runtime:addEventListener("enterFrame",removeFood)
end


for i = 0, totalFood do 
    timer.performWithDelay(600 * i, spawnFood)    -- Spawna un frutto ogni 600 millisecondi
                 
end






-- AGGIUNTA FRUTTO CORRETTO AL CONTATORE CORRECTFRUIT


local function fruttoCorretto(event)
    if event.phase == "began" then
        print(event.other.name)

                                                          -- Verifica se l'oggetto colliso è il frutto corretto
        if event.other.name == correctFood then
            audio.play(foodSound)

            correctFruit = correctFruit + 1
            print("hai preso "..correctFruit.. " frutti")
            
                                                               -- Rimuove il frutto corretto dal display
            event.other:removeSelf()
            
        end
    end
end


sensore:addEventListener("collision", fruttoCorretto)
chooseCorrectFood()








    end
end


-- RIMOZIONE SCENE (ROTTO PER COMPOSER SMINCHIATO)


function scene:destroy(event)           -- funzione destroy per rimozione oggetti da memoria
   


    local sceneGroup = self.view

        if checkBoxBackground then
            display.remove(checkBoxBackground)
            checkBoxBackground:removeSelf()
        end
        sceneGroup:remove(checkBoxBackground)

        if checkBox then
            display.remove(checkBox)
            checkBoxBackground:removeSelf()
        end
        sceneGroup:remove(checkBox)

        if limiteDestro then
            display.remove(limiteDestro)
            limiteDestro:removeSelf()
        end
        sceneGroup:remove(limiteDestro)

        if limiteSinistro then
            display.remove(limiteSinistro)
            limiteSinistro:removeSelf()
        end
        sceneGroup:remove(limiteSinistro)

        if cestinoLato then
            display.remove(cestinoLato)
            cestinoLato:removeSelf()
        end
        sceneGroup:remove(cestinoLato)

        if cestinoLato2 then 
            display.remove(cestinoLato2)
            cestinoLato2:removeSelf()
        end
        sceneGroup:remove(cestinoLato2)

        if cestinoFondo then
            display.remove(cestinoFondo)
            cestinoFondo:removeSelf()
        end
        sceneGroup:remove(cestinoFondo)

        if sfondoCestino then
            display.remove(sfondoCestino)
            sfondoCestino:removeSelf()
        end
        sceneGroup:remove(sfondoCestino)

        if sensore then
            sensore:removeEventListener("collision",fruttoCorretto)
            display.remove(sensore)
            sensore:removeSelf()
        end
        sceneGroup:remove(sensore)

        if prizeInterface then
            display.remove(prizeInterface)
            prizeInterface:removeSelf()
        end
        sceneGroup:remove(prizeInterface)


        if sfondoStella then
            display.remove(sfondoStella)
            sfondoStella:removeSelf()
        end
        sceneGroup:remove(sfondoStella)

        if sfondoStella2 then
            display.remove(sfondoStella2)
            sfondoStella2:removeSelf()
        end
        sceneGroup:remove(sfondoStella2)

        if sfondoStella3 then 
            display.remove(sfondoStella3)
            sfondoStella3:removeSelf()
        end
        sceneGroup:remove(sfondoStella3)

        if sfondoStella4 then
            display.remove(sfondoStella4)
            sfondoStella4:removeSelf()
        end
        sceneGroup:remove(sfondoStella4)

        if stellina1 then
            display.remove(stellina1)
            stellina1:removeSelf()
        end
        sceneGroup:remove(stellina1)

        if stellina2 then
            display.remove(stellina2)
            stellina2:removeSelf()
        end
        sceneGroup:remove(stellina2)

        if stellina3 then 
            display.remove(stellina3)
            stellina3:removeSelf()
        end
        sceneGroup:remove(stellina3)

        if stellina4 then
            display.remove(stellina4)
            stellina4:removeSelf()
        end
        sceneGroup:remove(stellina4)
        
        if correctFoodDisplay then
            display.remove(correctFoodDisplay)
            correctFoodDisplay:removeSelf()
        end
        sceneGroup:remove(correctFoodDisplay)

        if food then
            display.remove(food)
            food:removeSelf()
        end
        sceneGroup:remove(food)




        Runtime:removeEventListener("touch",movimentoMouse) 
        Runtime:removeEventListener("enterFrame", tornaIndrio)

        Runtime:removeEventListener("enterFrame",removeFood)


end



scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("destroy",scene)

return scene





































