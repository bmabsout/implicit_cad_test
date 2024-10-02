module Main where
import Graphics.Implicit
import Data.Function ( (&) )
import Linear
import System.Directory (renameFile)

object = difference (sphere 30) [cube True 40 & translate (V3 10 10 10)]

thickness = 3

ccylinder radius height = cylinder radius height & translate (V3 0 0 (-height/2.0))

bearing inner outer = ccylinder outer thickness `difference` [ccylinder inner thickness]


link:: Double -> SymbolicObj3
link len = difference stickWithCircles [ccylinder hole (thickness*2) & left, ccylinder hole (thickness*2) & right, erasers]
    where
        hole = 8
        outerRadius = hole + 5
        stickWithCircles = unionR 5 [cube True (V3 10 len thickness), ccylinder outerRadius thickness & left, ccylinder outerRadius thickness & right]
        left = translate $ V3 0 (-len/2.0) 0
        right = translate $ V3 (-2) (len/2.0) 0
        erasers = (cube True (V3 (outerRadius*2) (len*2) thickness) & translate (V3 0 0 thickness)) <> (cube True (V3 (outerRadius*2) (len*2) thickness) & translate (V3 0 0 (-thickness)))



main = do 
    writeBinSTL 5.0 "povclock.stl" (link 100)
    renameFile "povclock.stl" "render.stl"