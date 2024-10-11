import wollok.game.*
import main.*

object juegoAjedrez2{

  method iniciar(){
    game.height(5)
	  game.width(9)

    game.addVisualCharacter(reyNegro)
    spawnEnemigo.comenzarSpawn()

    keyboard.w().onPressDo({reyNegro.moverArriba()})
    keyboard.s().onPressDo({reyNegro.moverAbajo()})
	  keyboard.space().onPressDo({reyNegro.disparar()})
  }
}
  

object reyNegro {
  var vida = 100
  var puntaje = 0
  var position = game.at(0,2)

  var cooldown = 1

  method vida() = vida 
  method image() = "reyNegro.png" 

  method moverArriba() {
    if(position != game.at(0,4)) {
    position = position.up(1)
    }
  } 
  method moverAbajo() {
    if(position != game.at(0,0)) {
    position = position.down(1)
    }
  } 
  method position() = position 

  method disparar() {
    if(cooldown ==1){
      const balaNueva = new Bala()
      cooldown = 0
      game.addVisual(balaNueva)
      balaNueva.empezarMoverse()
      game.onCollideDo(balaNueva, {objeto=>self.reaccionar(objeto, balaNueva)})
      game.schedule(3000, { cooldown =1 })
    }
  }

  method reaccionar(objeto, bala){
    objeto.recibirDanio(50)
    game.removeVisual(bala)
  }

  method recibirDanio(danio) {
    vida -= danio
    game.say(self, "Mi vida es de " + vida)
    self.morir()
  }

  method morir() {
    if(vida == 0) {
      game.removeVisual(self)
    }
  }

  method sumarPuntos(enemigo) {
    puntaje += enemigo.puntaje()
  }

}

class Bala {
  var position = reyNegro.position().right(1)

  method image() = "bala.png" 
  method position() = position 

  method moverse() {
    if(position.x() == 8) {
      position = reyNegro.position().right(1)
      game.removeVisual(self)
    } else {
      position = position.right(1)
    }
  }
  method empezarMoverse() {
    game.onTick(1000, "moverse", {self.moverse()})
  }
  method recibirDanio(x){
  }
}

class Peon {
  var vida = 100
  const property puntaje = 100
  var position = game.at(8,0.randomUpTo(4).round())
  const property numeroAparicion = 1
  var danioAEfectuar = 20

  method position() = position 
  method image() = "peon.png" 

  method moverse() {
    if(position.x() == 0) {
      reyNegro.recibirDanio(danioAEfectuar)
      game.removeVisual(self)
    } else {
      position = position.left(1)
    }
  }

  method recibirDanio(danio) {
    vida = 0.max(vida - danio)
    self.morir()
    position = position.right(1)
  }

  method morir() {
    if(vida == 0) {
      reyNegro.sumarPuntos(self)
      danioAEfectuar = 0
      game.removeVisual(self)
    }
  }
  method empezarMoverse() {
	  game.onTick(1000,"moverse", {self.moverse()})
  }

}

class Caballo {

  method empezarMoverse() {
    game.onTick(1000, "moverseCaballo", {self.moverse()})
  }

  var vida = 75
  const property puntaje = 150
  var position = game.at(8,0.randomUpTo(4).round())
  const property numeroAparicion = 2
  var danioAEfectuar = 20

  method position() = position
  method image() = "caballo.png" 

  method moverse() {
    if(position.x() == 0) {
      reyNegro.recibirDanio(danioAEfectuar)
      game.removeVisual(self)
    } else {
      self.randomArribaOAbajo()
      if(arribaOAbajo>0){
        position = position.up(1)
        position = position.left(1)
      }
      else{
        position = position.down(1)
        position = position.left(1)
      }
    }
  }

  method recibirDanio(danio) {
    vida = 0.max(vida - danio)
    self.morir()
  }
  method morir() {
    if(vida == 0) {
      reyNegro.sumarPuntos(self)
      game.removeVisual(self)
      danioAEfectuar = 0
    }
  }

  var arribaOAbajo = 0

  method randomArribaOAbajo(){
    if( position.y() == 0){
      arribaOAbajo = 1
    }
    else{
      if(position.y() == 4){
        arribaOAbajo = -1
      }
      else{
          arribaOAbajo = (-1).randomUpTo(1).round()
      }
    }
  }


}

// class ALFIL {
//   var vida = 100
//   const property puntaje = 125
//   var position = game.at(8,0.randomUpTo(6))
//   const property numeroAparicion = 3

//   method position() = position
//   method image() = "alfil.png" 

//   method moverse() {
//     if(position.x() == 1) {
//       reyNegro.recibirDanio()
//       game.removeVisual(self)
//     } else {
//       if(vida >= 25) {
//         self.moverseArribaOAbajo()
//         position = position.left(1)
//       } else {
//         position = position.left(1)
//       }
//     }
//   }

//   method recibirDanio() {
//     vida = 0.max(vida - 25)
//   }
//   method morir() {
//     if(vida == 0) {
//       reyNegro.sumarPuntos(self)
//       game.removeVisual(self)
//     }
//   }

//   method moverseArribaOAbajo() {
//     var numero = 0.randomUpTo(3)

//     if(position.y() == 5) {
//       position = position.down(1)
//     } else {
//       if(position.y() == 0) {
//         position = position.up(1)
//       } else {
//         if(numero == 1) {
//       position = position.up(1)
//         } else {
//           position = position.down(1)
//         }
//       }
//     }
//   }
// }

// class TORRE {
//   var vida = 200
//   const property puntaje = 175
//   var position = game.at(8,0.randomUpTo(6))
//   const property numeroAparicion = 4

//   method position() = position
//   method image() = "torre.png" 

//   method moverse() {
//     if(position.x() == 1) {
//       reyNegro.recibirDanio()
//       game.removeVisual(self)
//     } else {
//       position = position.left(1)
//     }
//   }

//   method recibirDanio() {
//     vida = 0.max(vida - 25)
//   }
//   method morir() {
//     if(vida == 0) {
//       reyNegro.sumarPuntos(self)
//       game.removeVisual(self)
//     }
//   }
// }

// class REINA {
//   var vida = 175
//   const property puntaje = 200
//   var position = game.at(8,0.randomUpTo(6))
//   const property numeroAparicion = 5

//   method position() = position
//   method image() = "reina.png" 

//   method moverse() {
//     if(position.x() == 1) {
//       reyNegro.recibirDanio()
//       game.removeVisual(self)
//     } else {
//       if(vida >= 25) {
//         self.moverseArribaOAbajo()
//         position = position.left(1)
//       } else {
//         position = position.left(1)
//       }
//     }
//   }

//   method recibirDanio() {
//     vida = 0.max(vida - 25)
//   }
//   method morir() {
//     if(vida == 0) {
//       reyNegro.sumarPuntos(self)
//       game.removeVisual(self)
//     }
//   }

//   method moverseArribaOAbajo() {
//     var numero = 0.randomUpTo(3)

//     if(position.y() == 5) {
//       position = position.down(1)
//     } else {
//       if(position.y() == 0) {
//         position = position.up(1)
//       } else {
//         if(numero == 1) {
//       position = position.up(1)
//         } else {
//           position = position.down(1)
//         }
//       }
//     }
//   }
// }

// const caballo1 = new CABALLO()
// const alfil1 = new ALFIL()
// const torre1 = new TORRE()
// const reina1 = new REINA()

// Caballo -> Mueve rapido
// Alfin -> Al tener 25% se mueve arriba o abajo
// Torre -> Mucha vida
// Rey -> Mucha vida, mueve rapido y cada vez que le pegan se mueve para arriba o abajo


object spawnEnemigo {

  method comenzarSpawn() {
    game.onTick(5000, "apareceEnemigo", {self.aparecerPieza()})
  }

  var numeroPieza = 0

  method numeroRandom() {
    numeroPieza = 2.randomUpTo(2).round() // deberia ser up to 5
    numeroPieza = numeroPieza.round()
  }


  // para usar menos ifs podriamos hacer que cada tropa spawnee cada cierto tick 
  method aparecerPieza() {
    self.numeroRandom()
    if(numeroPieza == 1) {
      const peonNuevo = new Peon()
      game.addVisual(peonNuevo)
      peonNuevo.empezarMoverse()
    } 
    else {
      if(numeroPieza == 2) {
        const caballoNuevo = new Caballo()
        game.addVisual(caballoNuevo)
        caballoNuevo.empezarMoverse()
      } 
    }//else {
    //     if(numeroPieza == 3) {
    //       game.addVisual(alfil1)
    //     } else {
    //       if(numeroPieza == 4) {
    //         game.addVisual(torre1)
    //       } else {
    //         if(numeroPieza == 5) {
    //           game.addVisual(reina1)
    //         }
    //       }
    //     }
    //   }
    // }
  }
}

