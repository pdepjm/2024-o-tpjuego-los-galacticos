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

  method consecuenciaDisparo() {
    position = position.right(1)
  }


  // FUNCIONES PARA TESTS
  method vida() = vida
  method cambiarPosicion(posicion) {position = posicion}

}

class Peon inherits PiezaBlanca(vida = 100, puntajeDado = 50, danioAEfectuar = 25) {
  method image() = "peon.png" 
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
    imagenActual = "caballodañado.png"
    game.schedule(1000, { imagenActual = "caballo.png" }) 
  }

  
}

class Torre inherits PiezaBlanca(vida = 200, puntajeDado = 100, danioAEfectuar = 50, moverse = new Tick(interval = 3500, action = {self.moverse()})) {
  method image() = "torre.png"
}

class Alfil inherits PiezaBlanca(vida = 100, puntajeDado = 75, danioAEfectuar = 35) {
  var movimiento = [1,2].anyOne()
  method image() = "alfil.png"

  override method accionExtra() {
    if(position.y() == 0 || movimiento == 1) {
      self.moverseTodoParaArriba()
    }
    if(position.y() == game.height() || movimiento == 2) {
      self.moverseTodoParaAbajo()
    }
  } 
  method moverseTodoParaArriba() {
    movimiento = 1
    position = position.up(1)
  }
  method moverseTodoParaAbajo() {
    movimiento = 2
    position = position.down(1)
  }

  override method consecuenciaDisparo() {
    //desarrollar consecuencia (la idea era que se quede quieto un segundo)
  }
}

class Reina inherits Caballo(vida = 150, puntajeDado = 200, danioAEfectuar = 50, moverse = new Tick(interval = 2500, action = {self.moverse()})) {
  override method image() = "reina.png"
  override method consecuenciaDisparo() {
    //imagenActual = "reinadañada.png"
    //game.schedule(1000, { imagenActual = "reina.png" }) 
    danioAEfectuar *= 1.5
  }
}