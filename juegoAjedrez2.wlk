object juegoAjedrez2{

  method iniciar(){
    game.height(5)
	  game.width(9)

    game.addVisualCharacter(reyNegro)
    game.addVisual(peon1)
  }
}

object reyNegro {
  var vida = 100
  var puntaje = 0
  var position = game.at(0,2)

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
    game.addVisual(bala1)
  }

  method recibirDanio() {
    vida -= 20
    game.say(self, "Mi vida es de ")
  }

  method sumarPuntos(enemigo) {
    puntaje += enemigo.puntaje()
  }
}

class BALA {
  var position = reyNegro.position()

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
}

class PEON {
  var vida = 100
  const property puntaje = 100
  var position = game.at(8,0.randomUpTo(6))
  const property numeroAparicion = 1

  method position() = position 
  method image() = "peon.png" 

  method moverse() {
    if(position.x() == 1) {
      reyNegro.recibirDanio()
      game.removeVisual(self)
    } else {
    position = position.left(1)
    }
  }

  method recibirDanio() {
    vida = 0.max(vida - 25)
  }
  method morir() {
    if(vida == 0) {
      reyNegro.sumarPuntos(self)
      game.removeVisual(self)
    }
  }

}

class CABALLO {
  var vida = 75
  const property puntaje = 150
  var position = game.at(8,0.randomUpTo(6))
  const property numeroAparicion = 2

  method position() = position
  method image() = "caballo.png" 

  method moverse() {
    if(position.x() == 1) {
      reyNegro.recibirDanio()
      game.removeVisual(self)
    } else {
    position = position.left(1)
    }
  }

  method recibirDanio() {
    vida = 0.max(vida - 25)
  }
  method morir() {
    if(vida == 0) {
      reyNegro.sumarPuntos(self)
      game.removeVisual(self)
    }
  }

}

class ALFIL {
  var vida = 100
  const property puntaje = 125
  var position = game.at(8,0.randomUpTo(6))
  const property numeroAparicion = 3

  method position() = position
  method image() = "alfil.png" 

  method moverse() {
    if(position.x() == 1) {
      reyNegro.recibirDanio()
      game.removeVisual(self)
    } else {
      if(vida >= 25) {
        self.moverseArribaOAbajo()
        position = position.left(1)
      } else {
        position = position.left(1)
      }
    }
  }

  method recibirDanio() {
    vida = 0.max(vida - 25)
  }
  method morir() {
    if(vida == 0) {
      reyNegro.sumarPuntos(self)
      game.removeVisual(self)
    }
  }

  method moverseArribaOAbajo() {
    var numero = 0.randomUpTo(3)

    if(position.y() == 5) {
      position = position.down(1)
    } else {
      if(position.y() == 0) {
        position = position.up(1)
      } else {
        if(numero == 1) {
      position = position.up(1)
        } else {
          position = position.down(1)
        }
      }
    }
  }
}

class TORRE {
  var vida = 200
  const property puntaje = 175
  var position = game.at(8,0.randomUpTo(6))
  const property numeroAparicion = 4

  method position() = position
  method image() = "torre.png" 

  method moverse() {
    if(position.x() == 1) {
      reyNegro.recibirDanio()
      game.removeVisual(self)
    } else {
      position = position.left(1)
    }
  }

  method recibirDanio() {
    vida = 0.max(vida - 25)
  }
  method morir() {
    if(vida == 0) {
      reyNegro.sumarPuntos(self)
      game.removeVisual(self)
    }
  }
}

class REINA {
  var vida = 175
  const property puntaje = 200
  var position = game.at(8,0.randomUpTo(6))
  const property numeroAparicion = 5

  method position() = position
  method image() = "reina.png" 

  method moverse() {
    if(position.x() == 1) {
      reyNegro.recibirDanio()
      game.removeVisual(self)
    } else {
      if(vida >= 25) {
        self.moverseArribaOAbajo()
        position = position.left(1)
      } else {
        position = position.left(1)
      }
    }
  }

  method recibirDanio() {
    vida = 0.max(vida - 25)
  }
  method morir() {
    if(vida == 0) {
      reyNegro.sumarPuntos(self)
      game.removeVisual(self)
    }
  }

  method moverseArribaOAbajo() {
    var numero = 0.randomUpTo(3)

    if(position.y() == 5) {
      position = position.down(1)
    } else {
      if(position.y() == 0) {
        position = position.up(1)
      } else {
        if(numero == 1) {
      position = position.up(1)
        } else {
          position = position.down(1)
        }
      }
    }
  }
}

const peon1 = new PEON()
const caballo1 = new CABALLO()
const bala1 = new BALA()
const alfil1 = new ALFIL()
const torre1 = new TORRE()
const reina1 = new REINA()

// Caballo -> Mueve rapido
// Alfin -> Al tener 25% se mueve arriba o abajo
// Torre -> Mucha vida
// Rey -> Mucha vida, mueve rapido y cada vez que le pegan se mueve para arriba o abajo

object agregarEnemigo {
  var numeroPieza = 0

  method numeroRandom() {
    numeroPieza = 0.randomUpTo(6)
  }

  method aparecerPieza() {
    self.numeroRandom()
    if(numeroPieza == 1) {
      game.addVisual(peon1)
    } else {
      if(numeroPieza == 2) {
        game.addVisual(caballo1)
      } else {
        if(numeroPieza == 3) {
          game.addVisual(alfil1)
        } else {
          if(numeroPieza == 4) {
            game.addVisual(torre1)
          } else {
            if(numeroPieza == 5) {
              game.addVisual(reina1)
            }
          }
        }
      }
    }
  }
}