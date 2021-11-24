/*
FAU USP – Design T15 – 2021
PCS3021 - Linguagem Computacional
Prof. Ricardo Nakamura
Monitor Leonardo Prates Marques

TRABALHO 2 – JOGO DA MEMÓRIA

INTEGRANTES DO GRUPO
Arthur Siviero da Silva – 11832750
Everton Bela de Jesus Costa – 11841419
Gustavo Alves Machado – 11761507
Vitória Campos Moreira Tavares – 11761581
*/

// --------------------------------------- NOME DO JOGUINHO ----------------------------------------

import processing.sound.*; //comando da biblioteca de som do processing

SoundFile fundoMusic;
boolean estaTocandoFundo = false; //variável utilizada para evitar as repetições dos sons dentro do comando "draw"
SoundFile youwinMusic;
boolean estaTocandoYouwin = false; //variável utilizada para evitar as repetições dos sons dentro do comando "draw"
SoundFile caixaabertaMusic;
boolean estaTocandoCaixaaberta = false; //variável utilizada para evitar as repetições dos sons dentro do comando "draw"
SoundFile caixaerradaMusic;
boolean estaTocandoCaixaerrada= false; //variável utilizada para evitar as repetições dos sons dentro do comando "draw"
boolean direita = false;

PImage[] imagens, boneco_Esquerda_, boneco_Direita_, boneco_Subir_Direita, boneco_Subir_Esquerda;
int[] cartas;
boolean[] virada, marcada;

boolean ganhou;
PImage bicho, verso, start, startSelecionado, menu, menuSelecionado, retry, retrySelecionado, versoAtivado, menuPrincipal, jogoBG, Mouse, perdeu, ganhastes;
PImage bichoEsquerda, bichoPintandoEsquerda, bichoPintandoDireita, AnimaEsquerda, AnimaDireita;
int numPares, larguraCarta, alturaCarta, espacoEntreCartas, pxProtagonista, pyProtagonista, tela, passo, carta1, carta2, timer, ParesFeitos, numAnimacao, frameAtual, numColunas, numLinhas;
float t_inicial, t_max, t_passado, t_menos, t_erro;

void setup() {
  size(930,970);
  tela = 1;
  passo = 1;
  ParesFeitos = 0;

  imageMode(CENTER);
  // configurações do jogo
  numPares = 6;
  larguraCarta = 200;
  alturaCarta = 300;
  espacoEntreCartas = 10;
  numLinhas = 3;
  numColunas = 4;
  numAnimacao = 7;
  frameAtual = 0;
  t_max = 60;
  t_erro = 0;

  //Carrega fonte personalizada
  PFont myFont;
  myFont = createFont("Pixels.ttf",100);
  textFont (myFont);
  
  // configuração protagonista
  bichoEsquerda = loadImage("Boneco_Esquerda_0.png");
  bichoPintandoEsquerda = loadImage("Boneco Pintando Esquerda.png"); 
  bichoPintandoDireita = loadImage("Boneco Pintando Direita.png");
  pxProtagonista = width/2;
  pxProtagonista = height/2;
  bicho = bichoEsquerda;
  
  //Carrega imagens das cartas 
  verso = loadImage ("Caixa Fechada.jpg");
  versoAtivado = loadImage ("Caixa Fechada Marcada.jpg");
  imagens = new PImage[numPares];
  for (int contador = 0; contador < numPares; contador = contador + 1) {
    String nomeArquivo = "Caixa" + str(contador) + ".jpg"; 
    imagens[contador] = loadImage(nomeArquivo);
  }
  
  //Carrega imagens individuais das animações do bicho Esquerda e Direita
  
  boneco_Esquerda_ = new PImage[numAnimacao];
  for (int contador = 0; contador < numAnimacao; contador = contador + 1) {
    String nomeArquivo = "Boneco_Esquerda_" + str(contador) + ".png"; 
    boneco_Esquerda_[contador] = loadImage(nomeArquivo);
  }
  boneco_Direita_ = new PImage[numAnimacao];
  for (int contador = 0; contador < numAnimacao; contador = contador + 1) {
    String nomeArquivo = "Boneco_Direita_" + str(contador) + ".png"; 
    boneco_Direita_[contador] = loadImage(nomeArquivo);
  }
   boneco_Subir_Esquerda = new PImage[numAnimacao];
  for (int contador = 0; contador < numAnimacao; contador = contador + 1) {
    String nomeArquivo = "Boneco_Subir_Esquerda_" + str(contador) + ".png"; 
    boneco_Subir_Esquerda[contador] = loadImage(nomeArquivo);
  }
  boneco_Subir_Direita = new PImage[numAnimacao];
  for (int contador = 0; contador < numAnimacao; contador = contador + 1) {
    String nomeArquivo = "Boneco_Subir_Direita_" + str(contador) + ".png"; 
    boneco_Subir_Direita[contador] = loadImage(nomeArquivo);
  }
  
  //Carrega imagens de fundos
  menuPrincipal = loadImage ("menu principal.png");
  jogoBG = loadImage ("jogo.jpg");
  perdeu = loadImage ("YOULOSE.png");
  ganhastes = loadImage ("YOUWIN.jpg");
  
  //Carrega imagens de Botões e Mouse
  start = loadImage ("Start.png");
  startSelecionado = loadImage ("Start Selecionado.png");
  menu = loadImage ("Menu.png");
  menuSelecionado = loadImage ("Menu Selecionado.png");
  retry = loadImage  ("Retry.png");
  retrySelecionado = loadImage ("Retry Selecionado.png");
  Mouse = loadImage ("mouse.png");
  
  //Aloca posições no vetor (de 0 a 11)
  cartas = new int[numPares*2];  
  int c = 0;
  for (int i = 0; i < numPares*2; i = i + 2) {
    cartas[i] = c; 
    cartas[i + 1] = c;
    c = c + 1;
  }
  
  //Randomiza as Cartas
  for (int contador = 0; contador < 2*numPares; contador = contador + 1) {
    int cartaA = int(random(0, 10));
    int cartaB = int(random(0, 10));
    int temp = cartas[cartaA];
    cartas[cartaA] = cartas[cartaB];
    cartas[cartaB] = temp;
  }
  
  // o vetor "marcada" controla quais cartas estão marcadas
  marcada = new boolean[2*numPares];
  for (int contador = 0; contador < 2*numPares; contador = contador + 1) {
    marcada[contador] = false;
  }
  
  // o vetor "virada" controla quais cartas estão marcadas
  virada = new boolean[2*numPares];
  for (int contador = 0; contador < 2*numPares; contador = contador + 1) {
    virada[contador] = false;
  }
  
  fundoMusic = new SoundFile(this, "fundo.mp3"); //carrega a trilha de audio de dentro da pasta "data"
  youwinMusic = new SoundFile(this, "youwin.mp3"); //carrega a trilha de audio de dentro da pasta "data"
  caixaabertaMusic = new SoundFile(this, "caixaaberta.mp3"); //carrega a trilha de audio de dentro da pasta "data"
  caixaerradaMusic = new SoundFile(this, "caixaerrada.mp3"); //carrega a trilha de audio de dentro da pasta "data"
  
 noCursor();
}


void draw(){
   
  //----------------------------------TELA DO MENU--------------------------------------------------
  if (tela == 1){
  image (menuPrincipal, width/2, height/2, width, height);
  image (start, width/2, height/2, 360, 90);
    // Muda as músicas de acordo com a tela
    if (tela == 1 && estaTocandoFundo == false) {
      fundoMusic.loop();
      estaTocandoFundo = true;
      caixaerradaMusic.stop();
      estaTocandoCaixaerrada = false;
      caixaabertaMusic.stop();
      estaTocandoCaixaaberta= false;
      youwinMusic.stop();
      estaTocandoYouwin = false;}
    if (mouseX < width/2 + 180 && mouseX > width/2 - 180 && mouseY <height/2 +90/2 && mouseY > height/2 -90/2){
      image (startSelecionado, width/2, height/2, 360, 90);
      if (mousePressed == true && (mouseButton == LEFT)){  
        tela = 2;
        t_inicial = millis();
        t_menos = 0;
      }
    }
    image(Mouse, mouseX, mouseY);
  }  

  //----------------------------------TELA DO JOGO-------------------------------------------------
  if (tela == 2){
    background (10,10,60);
    //image (jogoBG, width/2, height/2, width, height);
    imageMode(CORNER);
    int px = 20;
    int py = 20;
    
      for (int h = 0; h < numLinhas; h = h + 1){
        for (int i = 0; i< numColunas; i = i + 1) {
        //Faz com que as cartas virem caso nenhuma tenha sido marcada
          if (passo == 1){
            if (virada[i+numColunas*h] == true) {
              image(imagens[cartas[i+numColunas*h]], px, py, larguraCarta, alturaCarta);
            }
          }

        //Faz com que as cartas apareçam marcadas, e faz o verso aparecer caso as cartas não estajam viradas (Acho que dá pra transformar parte em função, por estar meio repetitivo)
          if (marcada[i+numColunas*h] == true) {
            image(versoAtivado, px, py, larguraCarta, alturaCarta);
          }
          else if (virada[i+numColunas*h] == false){
            image(verso, px, py, larguraCarta, alturaCarta);
          }
          px = px + espacoEntreCartas+larguraCarta;
        }
      px = 20;
      py = py + espacoEntreCartas+alturaCarta;
      }  
  
      //Faz todas as cartas viradas voltarem ao verso quando alguma carta é marcada
      if (passo == 2){
        for (int contador = 0; contador < 2*numPares; contador = contador + 1) {
          virada[contador] = false;
      }
      }
  
    //Configura px e py novamente (estava dando bug sem)
    px = 20;
    py = 20;

    //Faz a carta virada desvirar automaticamente ao sair da área da carta (Acho que dá pra transformar parte em função, por estar meio repetitivo))
    for (int h = 0; h < numLinhas; h = h + 1){
      for (int i = 0; i< numColunas; i = i + 1) {
        if (testaTecla(pxProtagonista, pyProtagonista, px, py, larguraCarta, alturaCarta) == false) {
          if (virada[i + numColunas*h] == true) {
          virada[i + numColunas*h] = false;
          }
        }
        px = px + espacoEntreCartas+larguraCarta;
        }
      px = 20;
      py = py + espacoEntreCartas+alturaCarta;
    }
    

    //Faz com que, caso as cartas não sejam correspondentes, elas sejam desmarcadas
    if (passo == 3) {
      marcada[carta1] = false;
      marcada[carta2] = false;
      passo = 1;
      t_menos += 5;
      t_erro = millis();
    // Realiza o efeito sonoro de erro
    if ( estaTocandoCaixaerrada == false) {
      caixaerradaMusic.play();
      caixaabertaMusic.stop();
      estaTocandoCaixaaberta= false;
      youwinMusic.stop();
      estaTocandoYouwin = false;}
    }
 
    //Configurações do Protagonista
    imageMode(CENTER);
    image(bicho, pxProtagonista, pyProtagonista);
    
    
    // Coloca a animação em loop e muda o frame atual a cada 5 contagens do frame rate
    if (frameCount % 4 == 0) frameAtual = frameAtual+1;
    if (frameAtual == numAnimacao) frameAtual=0;
    
    //Faz o protagonista se mover e evita que ele saia pelas bordas, além de mudar o sprite
    if (keyPressed == true){
      if (key == 'd' || key == 'D'){
        if (pxProtagonista < width){
            pxProtagonista = pxProtagonista + 10;  
            bicho = boneco_Direita_[frameAtual];
            direita = true;                    
             
        }
      }
      if (key == 'a' || key == 'A'){
        if (pxProtagonista > 0){
            pxProtagonista = pxProtagonista - 10;
            bicho = boneco_Esquerda_[frameAtual];
            direita = false;
        }
      }
      if (key == 'w' || key == 'W'){
        if (pyProtagonista > 0){
        pyProtagonista = pyProtagonista - 10;
   
        
        if (direita==true){
           bicho = boneco_Subir_Direita[frameAtual];          
          }
        else if (direita == false) {
           bicho = boneco_Subir_Esquerda[frameAtual];
        }       
        
          if (bicho == bichoPintandoEsquerda){
         bicho = boneco_Esquerda_[frameAtual];
          }
          if (bicho == bichoPintandoDireita){
           bicho = boneco_Direita_[frameAtual];
          }
        }
      }
      if (key == 's' || key == 'S'){
        if (pyProtagonista < height){
          pyProtagonista = pyProtagonista + 10;
        if (direita==false){
          bicho = boneco_Esquerda_[frameAtual];
        }
        else if (direita == true) {
           bicho = boneco_Direita_[frameAtual];
        }
                
          if (bicho == bichoPintandoEsquerda){
          bicho = boneco_Esquerda_[frameAtual];
          }
          if (bicho == bichoPintandoDireita){
          bicho = boneco_Direita_[frameAtual];
          }
        }
      }
    }
    // Atualiza o timer
    t_passado = int((millis() - t_inicial)/1000);
    timer = int(t_max - t_menos - t_passado);
    if (t_passado <= t_max - t_menos) {
      textAlign (CENTER,TOP);
      textSize (120);
      // Define cor da letra (branca → default & vermelha → quando erra)
      if (int((millis() - t_erro)/1000) < 1) {
        fill (235,24,54);
      }
      else if (timer <= 30) {
        fill (243,180,0);
      }
      else {
        fill (255);
      }
      text (str(timer), width-38,-27);
    }
    // Encerra o jogo se o timer acabar
    else {
    ganhou = false;
    tela = 3;
    }
  }

    //Faz com que, caso todos os pares sejam feitos, o jogo acabe e vá para última tela 
    if (ParesFeitos == numPares){
    // Realiza o efeito sonoro de vitória
    if (estaTocandoYouwin == false)
    {
      youwinMusic.play();
      estaTocandoYouwin = true;
      caixaabertaMusic.stop();
      estaTocandoCaixaaberta = false;
      caixaerradaMusic.stop();
      estaTocandoCaixaerrada= false;}
      tela = 3;
      ganhou = true;
    }

  //----------------------------------TELA DE FIM-------------------------------------------------
  if (tela == 3){
    
    //Apresenta a tela de vitória ou de derrota, dependendo se o jogador ganhou ou não
    if (ganhou == true){
      image (ganhastes, width/2, height/2, width, height);
    }
    else{
      image (perdeu, width/2, height/2, width, height);
    }
    
    image (menu, width/2+225, height/2+200 , 360, 90);
    image (retry, width/2-225, height/2+200 , 360, 90);
  
    //Faz o botão de jogar novamente
    if (mouseX < width/2 - 225 + 180 && mouseX > width/2 - 225 - 180 && mouseY <height/2+200 +90/2 && mouseY > height/2+200 -90/2){
    image (retrySelecionado, width/2-225, height/2+200 , 360, 90);
      if (mousePressed == true && (mouseButton == LEFT)){ 
      tela = 2;
      reiniciarJogo();
      }
    }
    
    //Faz o botão de voltar ao menu
    if (mouseX < width/2 + 225 + 180 && mouseX > width/2 + 225 - 180 && mouseY <height/2+200 +90/2 && mouseY > height/2+200 -90/2){
    image (menuSelecionado, width/2+225, height/2+200 , 360, 90);
      if (mousePressed == true && (mouseButton == LEFT)){
      tela = 1;
      reiniciarJogo();
      }
    }  
    image(Mouse, mouseX, mouseY);
  }
}
  
//--------------------FUNÇÕES DE APERTAR TECLAS------------
void keyPressed(){
int px = 20;
int py = 20;
  if (passo == 1){
    //Configura a Tecla "L", que permite abrir as caixas caso elas não estejam marcadas. Detecta se o protagonista está dentro das cartas e faz com que ela vire caso sim
    if (key == 'l' || key == 'L'){ 
    // Realiza o efeito sonoro de abertura da caixa
      if ( estaTocandoCaixaaberta == false){
        caixaabertaMusic.play();
        caixaerradaMusic.stop();
        estaTocandoCaixaerrada= false;
        youwinMusic.stop();
        estaTocandoYouwin = false;}
    
   
      for (int h = 0; h < numLinhas; h = h + 1){
        for (int i = 0; i< numColunas; i = i + 1){
          if (testaTecla(pxProtagonista, pyProtagonista, px, py, larguraCarta, alturaCarta)) {
            if (virada[i+h*numColunas] == false) {
            virada[i+h*numColunas] = true;
            }
          }
          px = px + espacoEntreCartas+larguraCarta;
        }
         px = 20;
      py = py + espacoEntreCartas+alturaCarta;
      }
    }
  }
   
   //Configura a tecla "K", que permite marcar as caixas. 
   if (key == 'k' || key == 'K'){ 
     for (int h = 0; h < numLinhas; h = h + 1){
      for (int i = 0; i< numColunas; i = i + 1) {
       if (testaTecla(pxProtagonista, pyProtagonista, px, py, larguraCarta, alturaCarta)){
         if (marcada[i + h*numColunas] == false){
           //Muda o sprite do protagonista para ele pintando
           if (direita == true) {
             bicho = bichoPintandoDireita;
           }
           else if(direita == false) {
             bicho = bichoPintandoEsquerda;
           }
           //Reconhece se alguma carta já foi marcada, e faz com que sejam reconhecidas caso duas cartas iguais sejam marcadas
           if (passo == 1){
             marcada[i + h*numColunas] = true;
             carta1 = i + h*numColunas;
             passo = 2;
           }
           else if (passo == 2) {
             marcada[i + h*numColunas] = true;
             carta2 = i + h*numColunas;
               if (cartas[carta1] == cartas[carta2]) {
               passo = 1;
               ParesFeitos = ParesFeitos + 1;
               }
               else {
               passo = 3;
               }
             }
           }
         }
         px = px+espacoEntreCartas+larguraCarta;
        }
        px = 20;
        py = py + espacoEntreCartas+alturaCarta;
      }
    }
}

  //Função criada que testa se o protagonista está dentro da área de alguma carta
  boolean testaTecla(float x, float y, float rx, float ry, float rw, float rh) {
    if (rx <= x && x <= (rx + rw) && ry <= y && y <= (ry + rh)){
      return true;
    }
    else {
      return false;
    }
  }
  
  //Função que reinicia as propriedades do jogo quando o jogador que jogar novamente
  void reiniciarJogo(){
        ParesFeitos = 0;
        t_inicial = millis();
        t_menos = 0;
        pxProtagonista = width/2;
        pyProtagonista = height/2;

        //Randomiza as cartas e reseta o contador de ativado
        for (int contador = 0; contador < 2*numPares; contador = contador + 1) {
          int cartaA = int(random(0, 10));
          int cartaB = int(random(0, 10));
          int temp = cartas[cartaA];
          cartas[cartaA] = cartas[cartaB];
          cartas[cartaB] = temp;
        }
        for (int contador = 0; contador < 2*numPares; contador = contador + 1){
          marcada[contador] = false;
        }
        if (bicho == bichoPintandoEsquerda){
          bicho = boneco_Esquerda_[0];
          }
        if (bicho == bichoPintandoDireita){
          bicho = boneco_Direita_[0];
        }
  }
