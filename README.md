# PatinhoFeio
Repositório contendo documentação técnica sobre o Patinho Feio, primeiro computador brasileiro (Escola Politécnica da USP - 1971)

## 1975: Tese de mestrado do prof. João José Neto
* A tese de mestrado "Aspectos do Projeto de Software de um Minicomputador" de JJNeto (1975) apresenta os diversos componentes de software que foram desenvolvidos para o Patinho Feio, incluindo montador, desmontador, debugger e outras ferramentas.
* Disponível em: Aspectos_do_Projeto_de_Software_de_um_Minicomputador__JJNeto_1975_lowres.pdf
* Arquivos originais do escaneamento (para gerar imagens de maior resolução) disponíveis em: https://github.com/felipesanches/Aspectos_do_Projeto_de_Software_de_um_Minicomputador__JJNeto_1975

## 1977: Manual do Montador do Patinho Feio
* Este manual técnico foi o primeiro material relativo ao projeto do Patinho Feio que (eu, Felipe Sanches) tive acesso. Foi com base nas informações contidas aqui que grande parte do emulador do Patinho Feio junto ao projeto MAME foi desenvolvido. Os demais documentos foram (e continuam sendo) úteis para aprimorar o emulador e para complementar as informações técnicas.
* PDF disponível em: Montador_do_Patinho_Feio__Julho1977.pdf
* Arquivos originais do escaneamento (para gerar imagens de maior resolução) disponíveis em: https://github.com/felipesanches/Montador_do_Patinho_Feio__Julho1977/

## 1974/79: Livro do prof. Edson Fregni
* Recebi em 10/Maio/2016 autorização do prof. Edson Fregni para escaneamento e publicação na internet da íntegra do livro "Projeto de Computadores Digitais" de Edson Fregni e Glen George Langdon Jr. (com publicação original impressa em 1974 e reimpressões em 1977 e 1979)
* PDF disponível em: Projeto_de_Computadores_Digitais_2a_ed__EFregni_GLangdonJr_1974__reimpressao_de_1979__escaneamento_incompleto.pdf
* Arquivos originais do escaneamento (para gerar imagens de maior resolução) disponíveis em: https://gitlab.com/fsanches/Projeto_de_Computadores_Digitais_2a_ed

## 2003: Tese de mestrado de Marcia de Oliveira Cardoso
* Em 2003, Marcia de Oliveira Cardoso desenvolveu uma tese de mestrado entitulada "O Patinho Feio como construção sociotécnica", defendida no Instituto de Matemática da Universidade Federal do Rio de Janeiro – IM/UFRJ.
* [Dissertação completa] O_Patinho_Feio_como_Construção_Sociotécnica__Marcia_de_Oliveira_Cardoso__2003_dissertação_de_mestrado_UFRJ.pdf
* [Resumo para apresentação em congresso] O_Patinho_Feio_como_Construção_Sociotécnica__Marcia_de_Oliveira_Cardoso__2003_JoaoPessoa_XXII_ANPUH.pdf

## 2016: Listagem do pre-loader por JJN
* Em Maio de 2016 o professor João José Neto fez um esforço para transcrever, com base em memórias, trechos do programa micro-pré-loader. Este documento é um relatório que documenta este esforço e contém a listagem resultante. Existe, entretanto, a possibilidade de haver erros nessa listagem, devido à incerteza sobre a precisão das memórias de cerca de 4 décadas.
* PDF disponível em: Micro_Pré_Loader_do_Pato__JJN_2016-05-06.pdf

## 2016: Transcrição do micro pré-loader do Moshe Bain (por JJN)
* Em Mrio de 2016 o professor João José Neto encontrou em meio a seus pertences e transcreveu um documento antigo contendo a listagem do micro-pré-loader de autoria de Moshe Bain.
* PDF disponível em: Micro_pré_loader__Moshe_Bain_1977_07_21.pdf

# Arquivos binários

No diretório "binários" estão arquivos binários de programas para o Patinho:

## apendice_g__hexam.bin

* programa absoluto para ser carregado no endereço /E00
* Programa HEXAM, para manipular dados da memória por meio do console da teletype.
* transcrito da listagem do apendice g do manual do montador.
* CRC(e608f6d3)
* SHA1(3f76b5f91d9b2573e70919539d47752e7623e40a)

## exemplo_16.7.bin

* programa absoluto para ser carregado no endereço /006
* programa "hello world" extraído da página 16.7 do manual do montador. Imprime "PATINHO FEIO" na DECWRITER.
* CRC(0a87ac8d)
* SHA1(7c35ac3eed9ed239f2ef56c26e6f0c59f635e1ac)

## loader.bin

* programa absoluto a ser carregado no endereço /F80
* mero "placeholder". Arquivo inteiramente composto de zeros.
* O loader original da década de 70 ainda não foi encontrado.
* CRC(c2a8fa9d)
* SHA1(0ae4f711ef5d6e9d26c611fd2c8c8ac45ecbf9e7)

## micro-pre-loader.bin

* programa absoluto a ser carregado no endereço /000
* implementação mínimalista para facilitar a sua introdução manual pelo operador do computador em situações de bootstraping.
* Resgatado com base em memórias do professor João José Neto em Maio de 2016. Portanto, pode conter erros.
* CRC(1921feab)
* SHA1(bb063102e44e9ab963f95b45710141dc2c5046b0)
 
