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

    game.boardGround("fondo.png")
    menuInical.agregarMenuInicio()
    juegoPausado = true
    self.inicarTeclasUnicaVez()
    
  }

  method comenzarJuego() {
    juegoPausado = false
    self.agregarPersonaje(reyNegro)
    spawnEnemigo.comenzarSpawn()
    spawnEnemigo.comenzarOleadas()
  }

  method inicarTeclasUnicaVez() {
    if(nroJuego == 1) {
      keyboard.w().onPressDo({reyNegro.moverArriba()})
      keyboard.s().onPressDo({reyNegro.moverAbajo()})
      keyboard.space().onPressDo({reyNegro.disparar()})
      keyboard.p().onPressDo(
        {
          if(!juegoPausado && !menuInical.estaEnMenu()) {
              self.pausarJuego() 
              pausa.agregarTextoDePausa()
              }
          else self.reanudarJuego()
        }
      )
      keyboard.r().onPressDo(
        { 
          if(juegoTerminado) {
          reyNegro.reiniciarPersonaje()
          sistemaOleadas.reiniciarOleadas()
          self.removerVisual(puntajeFinal)
          self.iniciar()
          juegoPausado = false
          }  
        }
      )
      keyboard.enter().onPressDo(
        {
          if(menuInical.estaEnMenu()) {
            menuInical.quitarMenuInicio()
            self.comenzarJuego()
          }
        }
      )
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

object menuInical {
  var estaEnMenu = false
  method estaEnMenu() = estaEnMenu 
  method position() = game.center() 
  method text() = "PRESIONE ENTER PARA EMPEZAR"
  method color() = "000000"

  method agregarMenuInicio() {
    juegoAjedrez2.agregarVisual(self)
    estaEnMenu = true
  }
  method quitarMenuInicio() {
    juegoAjedrez2.removerVisual(self)
    estaEnMenu = false
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
    game.say(self, "VIDA =  " + vida)
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
}

class Reina inherits Caballo(vida = 150, puntajeDado = 200, danioAEfectuar = 50, moverse = new Tick(interval = 2500, action = {self.moverse()})) {
  override method image() = "reina.png"
  override method consecuenciaDisparo() {}
}

object spawnEnemigo {
  var oleadaAnterior = null

  method comenzarSpawn() {
    const oleadaInicial = new Tick(interval = 4500, action = {if(!juegoAjedrez2.estaPausado()) self.aparecerPieza()})
    juegoAjedrez2.agregarEvento(oleadaInicial)
    mensajeOleada.mostrarMensajeOleada()
    oleadaAnterior = oleadaInicial
  }

  method comenzarOleadas() {
    const oleadas = new Tick(interval = 30000, action = {
      if(!juegoAjedrez2.estaPausado()) {
      sistemaOleadas.nuevoTiempoSpawn(oleadaAnterior, oleadas)
      mensajeOleada.mostrarMensajeOleada()
      }
    })
    juegoAjedrez2.agregarEvento(oleadas)
  }

  method actualizarOleadaAnterior(nueva) {
      oleadaAnterior = nueva
  }

  method aparecerPieza() {
    // PROBABILIDAD PIEZAS
    // PEON = 30%
    // CABALLO = 20%
    // ALFIL = 20%
    // TORRE = 20%
    // REINA = 10%
    const pieza = [new Peon(), new Peon(), new Peon()
                  , new Caballo(), new Caballo()
                  , new Alfil(), new Alfil() 
                  ,new Torre(), new Torre()
                  ,new Reina()].anyOne()
    juegoAjedrez2.agregarVisual(pieza)
    pieza.empezarMoverse()
  }
}

object sistemaOleadas {
  var nroOleada = 0
  method nroOleada() {
    if(nroOleada != 3) {
      return nroOleada + 1
    } else {
      return "FINAL"
    }
  }
  const listaTiempos = [4000,3000,1500]

  method nuevoTiempoSpawn(oleadaAnterior, eventoOleada) {
    juegoAjedrez2.removerEvento(oleadaAnterior)

    const spawn = new Tick(interval = listaTiempos.get(nroOleada), action = {if(!juegoAjedrez2.estaPausado()) spawnEnemigo.aparecerPieza()})
    juegoAjedrez2.agregarEvento(spawn)

    if(nroOleada != 3) {
      nroOleada += 1 
      spawnEnemigo.actualizarOleadaAnterior(spawn)
    } else {
      juegoAjedrez2.removerEvento(eventoOleada)
    }
  }

  method reiniciarOleadas() {
    nroOleada = 0
  }

}

object mensajeOleada {
  method position() = game.center()
  method text() = "OLEADA " + sistemaOleadas.nroOleada()
  method textColor() = "D02323" 

  method mostrarMensajeOleada() {
    juegoAjedrez2.agregarVisual(self)
    game.schedule(1500, {juegoAjedrez2.removerVisual(self)})
  }

}
