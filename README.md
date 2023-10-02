# PC1
***
## Integrantes
- Juan de Dios Fernando Lerzundi Ríos
- José Daniel Zapata Ancco
- Omar Baldomero Vite Allca
- Daniel Ureta Espinal
***
## Introducción
## Objetivo
Comprender los pasos necesarios para crear, versionar e implementar una aplicación SaaS, incluido el seguimiento de las librerías de las que depende para que sus entornos de producción y desarrollo sean lo más similares posible.

## Creación y Versionado de una aplicación SaaS
- Crear un nuevo directorio y versionarlo con git
```bash
git init
```
- Crear un nuevo archivo llamado `Gemfile`
  ```Ruby
  source 'https://rubygems.org'
  ruby '2.6.6'
  gem 'sinatra', '>= 2.0.1'
  ```
- Ejecuta el comando `bundle` que examina tu `Gemfile`
```bash
bundle install
```
***
**¿Cuál es la diferencia entre el propósito y el contenido de `Gemfile` y `Gemfile.lock`?**

En estos archivos es donde se encuentran las dependencias, el principal propósito tanto de Gemfile como de Gemfile.lock es asegurar la consistencia en las versiones de las dependencias y proporcionar un entorno de desarrollo coherente.

**¿Qué archivo se necesita para reproducir completamente las gemas del entorno de desarrollo en el entorno de producción?**

Para reproducir en su totalidad las gemas necesitamos del archivo Gemfile.lock en el que se especifican detalladamente las dependencias y es el encargado junto a bundle de instalar las mismas versiones de las gemas en el servidor de producción.

**Después de ejecutar el bundle, ¿Por qué aparecen gemas en `Gemfile.lock` que no estaban en `Gemfile`?**

Esto generalmente sucede por que algunas gemas tienen subdependencias las cuales tambien son instaladas indirectamente por bundle. Como en nuestro ejemplo rack es una dependencia de sinatra mas no vemos rack en nuestro gemfile.


***
- Crea un archivo en tu proyecto llamado `app.rb` que contenga lo siguiente:
```Ruby
require 'sinatra'

class MyApp < Sinatra::Base
    get '/' do
        "<!DOCTYPE html><html><head></head><body><h1>Hello World</h1></body></html>"
    end
end
```
Para ejecutar la aplicación, tenemos que iniciar el servidor de aplicaciones y el servidor de nivel de presentación (web). El servidor de aplicaciones en rack está controlado por un archivo `config.ru`, que ahora debe crear y agregar al control de versiones, y que contiene lo siguiente:
```Ruby
require './app'

run MyApp
```
- Iniciamos el servidor de aplicaciones Rack y el servidor web WEBrick
```shell
bundle exec rackup --port 3000
```
***
**¿Qué sucede si intentas visitar una URL no raíz cómo https://localhost:3000/hello y por qué la raíz de tu URL variará?**

Al intentar vistar https://localhost:3000/hello estoy accediendo a la ruta '/hello' la cual no ha sido definida en el código, solo la ruta raiz '/':
```Ruby
get '/' do
  "<!DOCTYPE html><html><head></head><body><h1>Hello World</h1></body></html>"
end
```
***
- Modifica app.rb para que en lugar de "Hello world" imprime "Goodbye world"
>Si modificas tu aplicación mientras se está ejecutando, debes reiniciar 
Rack para que "veas" esos cambios
- Usaremos la gema de `rerun`, que reinicia Rack automáticamente cuando ve cambios en los archivos en el directorio de la aplicación.
-  Agrega lo siguiente al Gemfile:
```Ruby
group :development do
  gem 'rerun'
end
```
## Parte 1: Wordguesser
Con toda esta maquinaria en mente, clona este repositorio y trabajemos el juego de adivinar palabras (Wordguesser).
```bash
git clone https://github.com/saasbook/hw-sinatra-saas-wordguesser

cd hw-sinatra-saas-wordguesser

bundle
```
- Clonamos el repositorio correctamente

![image](https://github.com/Jxtrex/CC3S2-PC1/assets/90808325/168a5c51-e192-41bd-a63b-70379978c80a)

- Instalamos todas las gemas faltantes

![image](https://github.com/Jxtrex/CC3S2-PC1/assets/90808325/44f31a1a-c2a7-4799-b6df-4085dfadaf76)

Instalamos todas las gemas faltantes

En el directorio raíz de la aplicación, escribe `bundle exec autotest`

![image](https://github.com/Jxtrex/CC3S2-PC1/assets/90808325/f8ab2131-9a3b-4ed3-bf8a-db61d58c2e6b)

Ahora, con Autotest aun ejecutándose, elimina `:pending => true` y guarde el archivo. Deberías ver inmediatamente que Autotest se activa y vuelve a ejecutar las pruebas. Ahora debería tener 18 ejemplos, 1 fallido y 17 pendientes

Eliminamos `:pending => true` en cada especificacion (spec)

```ruby
  describe 'new' , :pending => true do
    it "takess a parameter and returns a WordGuesserGame object" do      
      @game = WordGuesserGame.new('glorp')
      expect(@game).to be_an_instance_of(WordGuesserGame)
      expect(@game.word).to eq('glorp')
      expect(@game.guesses).to eq('')
      expect(@game.wrong_guesses).to eq('')
    end
  end
....
#Continúa el código
....
```

Ahora debería tener 18 ejemplos, 1 fallido y 17 pendientes.

![image](https://github.com/Jxtrex/CC3S2-PC1/assets/90808325/c3b0b5f5-54b3-4013-933c-5702d517bb54)

Nuestro código quedaría de esta manera:

```ruby
require 'spec_helper'
require 'wordguesser_game'

describe WordGuesserGame do
  # helper function: make several guesses
  def guess_several_letters(game, letters)
    letters.chars do |letter|
      game.guess(letter)
    end
  end

  describe 'new' do
    it "takess a parameter and returns a WordGuesserGame object" do      
      @game = WordGuesserGame.new('glorp')
      expect(@game).to be_an_instance_of(WordGuesserGame)
      expect(@game.word).to eq('glorp')
      expect(@game.guesses).to eq('')
      expect(@game.wrong_guesses).to eq('')
    end
  end

  describe 'guessing' do
    context 'correctly' do
      before :each do
        @game = WordGuesserGame.new('garply')
        @valid = @game.guess('a')
      end
      it 'changes correct guess list', :pending => true do
        expect(@game.guesses).to eq('a')
        expect(@game.wrong_guesses).to eq('')
      end
      it 'returns true' do
        expect(@valid).not_to be false
      end
    end
    context 'incorrectly' do
      before :each do
        @game = WordGuesserGame.new('garply')
        @valid = @game.guess('z')
      end
      it 'changes wrong guess list' do
        expect(@game.guesses).to eq('')
        expect(@game.wrong_guesses).to eq('z')
      end
      it 'returns true' do
        expect(@valid).not_to be false
      end
    end
    context 'same letter repeatedly' do
      before :each do
        @game = WordGuesserGame.new('garply')
        guess_several_letters(@game, 'aq')
      end
      it 'does not change correct guess list' do
        @game.guess('a')
        expect(@game.guesses).to eq('a')
      end
      it 'does not change wrong guess list' do
        @game.guess('q')
        expect(@game.wrong_guesses).to eq('q')
      end
      it 'returns false' do
        expect(@game.guess('a')).to be false
        expect(@game.guess('q')).to be false
      end
      it 'is case insensitive' do
        expect(@game.guess('A')).to be false
        expect(@game.guess('Q')).to be false
        expect(@game.guesses).not_to include('A')
        expect(@game.wrong_guesses).not_to include('Q')
      end
    end
    context 'invalid' do
      before :each do
        @game = WordGuesserGame.new('foobar')
      end
      it 'throws an error when empty' do
        expect { @game.guess('') }.to raise_error(ArgumentError)
      end
      it 'throws an error when not a letter' do
        expect { @game.guess('%') }.to raise_error(ArgumentError)
      end
      it 'throws an error when nil'do
        expect { @game.guess(nil) }.to raise_error(ArgumentError)
      end
    end
  end

  describe 'displayed word with guesses'do
    before :each do
      @game = WordGuesserGame.new('banana')
    end
    # for a given set of guesses, what should the word look like?
    @test_cases = {
      'bn' =>  'b-n-n-',
      'def' => '------',
      'ban' => 'banana'
    }
    @test_cases.each_pair do |guesses, displayed|
      it "should be '#{displayed}' when guesses are '#{guesses}'" do
        guess_several_letters(@game, guesses)
        expect(@game.word_with_guesses).to eq(displayed)
      end
    end
  end

  describe 'game status' do
    before :each do 
      @game = WordGuesserGame.new('dog')
    end
    it 'should be win when all letters guessed' do
      guess_several_letters(@game, 'ogd')
      expect(@game.check_win_or_lose).to eq(:win)
    end
    it 'should be lose after 7 incorrect guesses' do
      guess_several_letters(@game, 'tuvwxyz')
      expect(@game.check_win_or_lose).to eq(:lose)
    end
    it 'should continue play if neither win nor lose' do
      guess_several_letters(@game, 'do')
      expect(@game.check_win_or_lose).to eq(:play)
    end
  end
end
```
***
Preguntas

Según los casos de prueba, ¿cuántos argumentos espera el constructor de la clase de juegos (identifica la clase) y, por lo tanto, cómo será la primera línea de la definición del método que debes agregar a `wordguesser_game.rb`?

El constructor de la clase `WordGuesserGame` no espera ningún argumento, ya que en la prueba de `"new"`, se crea una nueva instancia de `WordGuesserGame` de la siguiente manera: 

```ruby
@game = WordGuesserGame.new('glorp') 
```

Sin embargo, para que el constructor no espere ningún argumento, se debe modificar la definición del constructor en el archivo `wordguesser_game.rb` como se mencionó anteriormente: 

```ruby
def initialize 

  # Código para inicializar las variables de instancia 

end 
```

Esto garantiza que el constructor no espere ningún argumento al crear una nueva instancia de `WordGuesserGame`.
***

Según las pruebas de este bloque describe, ¿qué variables de instancia se espera que tenga `WordGuesserGame`?

Se espera que las variables de instancia `@word, @guesses, y @wrong_guesses` existan y estén inicializadas correctamente cuando se crea una nueva instancia de `WordGuesserGame`. 

***

Echa un vistazo al código del método de clase `get_random_word`, que recupera una palabra aleatoria de un servicio web que encontramos que hace precisamente eso. Utiliza el siguiente comando para verificar que el servicio web funcione así. Ejecútalo varias veces para verificar que obtengas palabras diferentes.

```bash
$ curl --data '' http://randomword.saasbook.info/RandomWord
```

Lo ejecutamos 3 veces y obtenemos las palabras scrawny, tricky y habitual

![image](https://github.com/Jxtrex/CC3S2-PC1/assets/90808325/1b343ba6-7413-4250-898a-09f16bf191ee)

***
## Parte 2: RESTful para Wordguesser
...
## Parte 3: Conexión de WordGuesserGame a Sinatra
...
## Parte 4: Cucumber
...
## Parte 5: Otros casos
...
