import wollok.game.*
import main.*
import juegoAjedrez.*
import reyNegro.*

class PiezaBlanca {
  const moverse = new Tick(interval = 2000, action = {self.moverse()})
  method empezarMoverse() {
    juegoAjedrez2.agregarEvento(moverse)
  }
  var vida
  const puntajeDado
  var position = game.at(game.width() - 1, [0,1,2,3,4].anyOne())
  var danioAEfectuar

  method position() = position

  method moverse() {
    if(!juegoAjedrez2.estaPausado()) {
      if(position.x() == 1) {
        reyNegro.recibirDanio(danioAEfectuar)
        self.morir(true)
      } else {
        self.accionExtra()
        position = position.left(1)
      }
    }
  }

  method accionExtra() {}

  method recibirDanio(danio) {
    vida = vida - danio
    vida = 0.max(vida)
    self.morir(false)
    self.consecuenciaDisparo()
  }

  method morir(llegoFinal) {
    if(vida == 0) {
      reyNegro.sumarPuntos(puntajeDado)
      juegoAjedrez2.removerEvento(moverse)
      juegoAjedrez2.removerVisual(self)
    } else if(llegoFinal) {
      juegoAjedrez2.removerEvento(moverse)
      juegoAjedrez2.removerVisual(self)
    }
  }

  method consecuenciaDisparo()

  // FUNCIONES PARA TESTS
  method vida() = vida
  method cambiarPosicion(posicion) {position = posicion}
  method danio() = danioAEfectuar
}

class Peon inherits PiezaBlanca(vida = 100, puntajeDado = 50, danioAEfectuar = 25) {
  var imagenActual = "peon.png"
  method image() = imagenActual

  override method consecuenciaDisparo() {
    position = position.right(1)
    imagenActual = "peonGolpeado.png"
    game.schedule(1000, { imagenActual = "peon.png" }) 
  }
}

class Caballo inherits PiezaBlanca(vida = 75, puntajeDado = 75, danioAEfectuar = 15) {
  var imagenActual = "caballo.png"
  method image() = imagenActual

  override method accionExtra() {
    if(position.y() == 0) {
      position = position.up(1)
    } else if(position.y() == game.height()-1) {
      position = position.down(1)
    } else {
      position = [position.up(1),position.down(1)].anyOne()
    }
  }

  override method consecuenciaDisparo() {
    imagenActual = "caballoGolpeado.png"
  }
}

class Torre inherits PiezaBlanca(vida = 200, puntajeDado = 100, danioAEfectuar = 50, moverse = new Tick(interval = 3500, action = {self.moverse()})) {
  var imagenActual = "torre.png"
  method image() = imagenActual  override method consecuenciaDisparo(){
    imagenActual = "torreGolpeada.png"
  }
}

class Alfil inherits PiezaBlanca(vida = 100, puntajeDado = 75, danioAEfectuar = 35, moverse = new Tick(interval = 3500, action = {if(!stun) self.moverse()})) {
  var movimiento = [1,2].anyOne() // 1 = Moverse siempre hacia arriba || 2 = Moverse siempre hacia abajo
  var stun = false
  var imagenActual = "alfil.png"
  method image() = imagenActual

  override method accionExtra() {
    if(position.y() == 0) {
      movimiento = 1
    } else if(position.y() == game.height() - 1) {
      movimiento = 2
    }
    
    if(movimiento == 1) {
      position = position.up(1)
    } else if(movimiento == 2) {
      position = position.down(1)
    }
  } 

  override method consecuenciaDisparo() {
    imagenActual = "alfilGolpeado.png"
    game.schedule(2000, { imagenActual = "alfil.png"}) 
    stun = true
    game.schedule(2000, {stun = false})
  }
}

class Reina inherits Caballo(vida = 150, puntajeDado = 200, danioAEfectuar = 50, moverse = new Tick(interval = 1000, action = {self.moverse()})) {
  override method image() = imagen
  var imagen = "reina.png"
  override method consecuenciaDisparo() {
    imagen = "reinaGolpeada.png"
    danioAEfectuar *= 1.5
  }
}