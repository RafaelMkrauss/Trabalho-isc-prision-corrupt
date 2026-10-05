# Prision Corrupt: jogo em Assembly RISC-V

Jogo feito como trabalho da disciplina Introdução aos Sistemas Computacionais (ISC) da UnB, escrito inteiramente em Assembly RISC-V. A imagem é desenhada direto na memória de vídeo (display bitmap) e o teclado é lido por MMIO, sem nenhuma biblioteca gráfica.

<!-- Adicione aqui um GIF do jogo rodando, por exemplo: ![Gameplay](gameplay.gif) -->

## O jogo

Você controla um policial dentro de uma prisão. Os presos aparecem em celas sorteadas a cada fase, e o objetivo é derrotar todos eles enquanto desvia das balas que caem do alto da tela. O policial tem 4 vidas; quando todos os presos de uma fase são derrotados, o jogo avança para a próxima. São 4 fases, com tela de game over e tela final.

O que foi implementado:

- menu, tela de instruções e tela de cheats;
- movimentação e ataque com animação dos sprites do policial e dos presos (padrão, ataque, dano e morte);
- posições dos presos sorteadas sem repetição a cada fase;
- balas geradas aleatoriamente, com detecção de colisão e perda de vida;
- placar, música de fundo e efeitos sonoros;
- desenho em dois frames de vídeo para evitar que a tela pisque.

## Controles

| Tecla | Ação |
| --- | --- |
| `1` | Começar o jogo (no menu) |
| `2` | Instruções (no menu) |
| `W` `A` `S` `D` | Mover o policial |
| `F` | Atacar |
| `Espaço` | Continuar / voltar ao menu |

## Como rodar

O executável do FPGRARS e o RARS usados na disciplina estão na pasta `prision corrupt`.

```bash
cd "prision corrupt"
fpgrars-x86_64-pc-windows-msvc--unb.exe "prision corrupt.s"
```

Também é possível abrir `prision corrupt.s` no RARS incluído (`Rars16_Custom1.jar`), conectar as ferramentas Bitmap Display e Keyboard and Display MMIO Simulator, montar e executar.
