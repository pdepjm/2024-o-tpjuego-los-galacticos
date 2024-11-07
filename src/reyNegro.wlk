import wollok.game.*
import main.*
import juegoAjedrez.*
import piezasBlancas.*
import menu.*



object reyNegro {
  var vida = 100
  var puntaje = 0
  var position = game.at(0,2)
  var cooldown = 1


  method vida() = vida 
  method image() = "reyNegro.png" 
  method puntaje() = puntaje

  method moverArriba() {
    if(position != game.at(0,4) && !juegoAjedrez2.estaPausado() ) {
    position = position.up(1)
    }
  } 
  method moverAbajo() {
    if(position != game.at(0,0) && !juegoAjedrez2.estaPausado()) {
    position = position.down(1)
    }
  } 
  method position() = position 

  method disparar() {
    if(cooldown == 1 && !juegoAjedrez2.estaPausado()){
      const balaNueva = new Bala()
      cooldown = 0
      juegoAjedrez2.agregarVisual(balaNueva)
      balaNueva.empezarMoverse()
      game.onCollideDo(balaNueva, {objeto=>self.reaccionar(objeto, balaNueva)})
      game.schedule(1000, { cooldown =1 })
    }
  }

  method reaccionar(objeto, bala){
    objeto.recibirDanio(50)
    juegoAjedrez2.removerVisual(bala)
  }

  method recibirDanio(danio) {
    vida = vida - danio
    vida = 0.max(vida)
    game.say(self, "VIDA =  " + vida)
    self.morir()
  }

  method morir() {
    if(vida == 0) {
      puntajeFinal.terminarJuego()
      juegoAjedrez2.removerPersonaje(self)
    }
  }

  method sumarPuntos(puntosObtenidos) {
    puntaje = puntaje + puntosObtenidos
  }

  method reiniciarPersonaje() {
    vida = 100
    puntaje = 0
    position = game.at(0,2)
  }
}

class Bala {
  const moverse = new Tick(interval = 200, action = {if(!juegoAjedrez2.estaPausado()) self.moverse()})
  var position = reyNegro.position().right(1)

  method image() = "bala.png" 
  method position() = position 

  method moverse() {
    if(position.x() == game.width() - 1) {
      juegoAjedrez2.removerVisual(self)
      juegoAjedrez2.removerEvento(moverse)
    } else {
      position = position.right(1)
    }
  }
  method empezarMoverse() {
    juegoAjedrez2.agregarEvento(moverse)
  }

}