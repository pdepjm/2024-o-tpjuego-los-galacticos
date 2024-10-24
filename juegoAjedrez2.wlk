import wollok.game.*
import main.*

object juegoAjedrez2{

  var nroJuego = 1
  var juegoPausado = false
  method estaPausado() = juegoPausado
  var juegoTerminado = false
  method termino() = juegoTerminado

  const listaVisuales = []
  const listaEventos = []
  const listaPersonajes = []
  
  method iniciar(){
    game.height(5)
	  game.width(9)

    self.agregarPersonaje(reyNegro)
    game.boardGround("fondo.png")
    spawnEnemigo.comenzarSpawn()
    self.inicarTeclasUnicaVez()
  }

  method inicarTeclasUnicaVez() {
    if(nroJuego == 1) {
      keyboard.w().onPressDo({reyNegro.moverArriba()})
      keyboard.s().onPressDo({reyNegro.moverAbajo()})
      keyboard.space().onPressDo({reyNegro.disparar()})
      keyboard.p().onPressDo({
        if(!juegoPausado) {
            self.pausarJuego() 
            pausa.agregarTextoDePausa()
            }
        else self.reanudarJuego()
      })
      keyboard.r().onPressDo(
        { if(juegoTerminado) {
          reyNegro.reiniciarPersonaje()
          self.removerVisual(puntajeFinal)
          self.iniciar()
          juegoPausado = false
          }  
        })
      nroJuego += 1
    }
  }

  method agregarPersonaje(personaje) {
    game.addVisualCharacter(personaje)
    listaPersonajes.add(personaje)
  }
  method agregarVisual(visual) {
    game.addVisual(visual)
    listaVisuales.add(visual)
  }
  method agregarEvento(evento) {
    listaEventos.add(evento)
    evento.start()
  }
  method removerVisual(visual) {
    game.removeVisual(visual)
    listaVisuales.remove(visual)
  }
  method removerEvento(evento) {
    evento.stop()
    listaEventos.remove(evento)
  }
  method removerPersonaje(personaje) {
    game.removeVisual(personaje)
    listaPersonajes.remove(personaje)    
  }
  method bloquearTeclasMovimientoRey() {
    
  }

  method pausarJuego() { 
      juegoPausado = true
      game.say(self, "Presione P para reanudar el juego")      
  }
  method reanudarJuego() {
      juegoPausado = false
      pausa.quitarTextoPausa()
  }

  method terminarJuego() {
    juegoPausado = true
    listaEventos.forEach({evento => self.removerEvento(evento)})
    listaVisuales.forEach({visual => self.removerVisual(visual)})
    listaPersonajes.forEach({personaje => self.removerPersonaje(personaje)})
    juegoTerminado = true
  }
  
}

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
    game.say(self, "Mi vida es de " + vida)
    self.morir()
  }

  method morir() {
    if(vida == 0) {
      puntajeFinal.terminarJuego()
      juegoAjedrez2.removerPersonaje(self)
    }
  }

  method sumarPuntos(enemigo) {
    puntaje = puntaje + enemigo.puntaje()
  }

  method reiniciarPersonaje() {
    vida = 100
    puntaje = 0
    position = game.at(0,2)
  }
}

object puntajeFinal {
  var puntaje = 0
  method position() = game.center()
  method text() = "EL PUNTAJE FUE DE " + puntaje + " PUNTOS, PRESIONE R PARA REINICIAR"
  method textColor() = "D02323" 

  method actualizarPuntaje() {
    puntaje = reyNegro.puntaje()
  }
  method terminarJuego() {
    self.actualizarPuntaje()
    juegoAjedrez2.terminarJuego()
    juegoAjedrez2.agregarVisual(self)
  }
}

object pausa{
  method position() = game.center()
  method text() = "ESTAS EN PAUSA, PRESIONE P PARA SEGUIR JUGANDO"
  method textColor() = "D02323"
  
  method agregarTextoDePausa() {
    juegoAjedrez2.agregarVisual(self)
  }
  method quitarTextoPausa() {
    juegoAjedrez2.removerVisual(self)
  }
}

class Bala {
  const moverse = new Tick(interval = 200, action = {self.moverse()})
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

class PiezaBlanca {
  const moverse = new Tick(interval = 2000, action = {self.moverse()})
  method empezarMoverse() {
    juegoAjedrez2.agregarEvento(moverse)
  }
  var vida
  const puntajeDado
  var position = game.at(game.width() - 1, [0,1,2,3,4].anyOne())
  const danioAEfectuar

  method position() = position
  method puntaje() = puntajeDado

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
    vida = 0.max(vida - danio)
    self.morir(false)
    self.consecuenciaDisparo()
  }

  method morir(llegoFinal) {
    if(vida == 0) {
      reyNegro.sumarPuntos(self)
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

class Peon inherits PiezaBlanca(vida = 100, puntajeDado = 50, danioAEfectuar = 100) {
  method image() = "peon.png" 
}

class Caballo inherits PiezaBlanca(vida = 75, puntajeDado = 100, danioAEfectuar = 15) {
  var imagenActual = "caballo.png"
  method image() = imagenActual

  override method accionExtra() {
    if(position.y() == 0) {
      position = position.up(1)
    } else if(position.y() == 4) {
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




// class Peon1 {
//   const moverse = new Tick(interval = 1500, action = {self.moverse()})

//   method empezarMoverse() {
//     juegoAjedrez2.agregarEvento(moverse)
//   }

//   var vida = 100
//   const property puntaje = 100
//   var position = game.at(8,0.randomUpTo(4).round())
//   const danioAEfectuar = 100000

//   method position() = position 
//   method image() = "peon.png" 

//   method moverse() {
//     if(!juegoAjedrez2.estaPausado()) {
//       if(position.x() == 1) {
//       reyNegro.recibirDanio(danioAEfectuar)
//       self.morir(true)
//       } else {
//         position = position.left(1)
//       }
//     }
//   }

//   method recibirDanio(danio) {
//     vida = vida - danio
//     vida = 0.max(vida)
//     self.morir(false)
//     position = position.right(1)
//   }

//   method morir(llegoFinal) {
//     if(vida == 0) {
//       reyNegro.sumarPuntos(self)
//       juegoAjedrez2.removerEvento(moverse)
//       juegoAjedrez2.removerVisual(self)
//     } else if(llegoFinal) {
//       juegoAjedrez2.removerEvento(moverse)
//       juegoAjedrez2.removerVisual(self)
//     }
//   }


//   // FUNCIONES PARA TESTS
//   method vida() = vida 
//   method cambiarPosicion(nueva) { position = nueva}
// }

// class Caballo1 {
//   const moverse = new Tick(interval = 2000, action = {self.moverse()})

//   method empezarMoverse() {
//     juegoAjedrez2.agregarEvento(moverse)
//   }

//   var vida = 75
//   const property puntaje = 150
//   var position = game.at(8,0.randomUpTo(4).round())
//   const danioAEfectuar = 20

//   method position() = position

//   var imagenActual = "caballo.png"
//   method image() = imagenActual

//   method moverse() {
//     if(!juegoAjedrez2.estaPausado()) {
//       if(position.x() == 1) {
//         reyNegro.recibirDanio(danioAEfectuar)
//         self.morir(true)
//       } else {
//         self.randomArribaOAbajo()
//         position = position.left(1)
//       }
//     }
//   }

//   method randomArribaOAbajo() {
//     if(position.y() == 0) {
//       position = position.up(1)
//     } else if(position.y() == 4) {
//       position = position.down(1)
//     } else {
//       position = [position.up(1),position.down(1)].anyOne()
//     }
//   }

//   method recibirDanio(danio) {
//     vida = vida - danio
//     vida = 0.max(vida)
//     self.cambiarImagenTemporal()
//     self.morir(false)
//   }

//   method cambiarImagenTemporal(){
//     imagenActual = "caballodañado.png" // Cambia la imagen a 'caballodañado.png'
//     game.schedule(1000, { imagenActual = "caballo.png" }) // Después de 1 segundo, restaura la imagen original
//   }

//   method morir(llegoFinal) {
//     if(vida == 0) {
//     reyNegro.sumarPuntos(self)
//     juegoAjedrez2.removerEvento(moverse)
//     juegoAjedrez2.removerVisual(self)
//     } else if(llegoFinal) {
//     juegoAjedrez2.removerEvento(moverse)
//     juegoAjedrez2.removerVisual(self)
//     }
//   }

// }

object spawnEnemigo {
  method comenzarSpawn() {
    const spawn = new Tick(interval = 3000, action = {if(!juegoAjedrez2.estaPausado()) self.aparecerPieza()})
    juegoAjedrez2.agregarEvento(spawn)
  }

  method aparecerPieza() {
    const pieza = [new Peon(), new Caballo()].anyOne()
    juegoAjedrez2.agregarVisual(pieza)
    pieza.empezarMoverse()
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