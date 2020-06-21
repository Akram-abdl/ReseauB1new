# TP Exploration de l'OS et du matériel

## Sujet 2 : Débugger et désassembler des programmes compilés

### Hello World

- commencer par coder puis compiler un programme Hello World en C

```C
#include <stdio.h>
int main() {
   printf("Hello World!");
   return 0;
}
```

- désassembler le programme et mettre en évidence:
    - où est stockée la chaîne de caractère "Hello World"

Pour cela j'ai installé le programme Ghidra dans lequel j'ai ouvert mon programme HelloWorld compilé.
J'ai eu ainsi accés au code assembleur du programme. J'ai donc fais une recherche de mot clés "Hello World!".
Ainsi j'ai pus constater qu'elle est stockée sur le registre SI.

### Winrar crack

Winrar est un programme qui permet de manipuler des archives (.rar, .zip, etc).

Winrar est un programme payant qui possède une version d'évaluation. Une fois cette période d'évaluation dépassée, le programme nous rappelle régulièrement qu'il est nécessaire d'acheter le produit pour continuer à l'acheter (oupa).

Le but de cette section est de crack Winrar afin d'avoir une version utilisable comme une version achetée. (j'ai testé avec la version que j'avais sous la main : 5.4)


- Pour cela j'ai cherché le jump qui renvoyait à la string du popup concernant la demande d'activation de winrar et j'ai remplacé par un NOP (Pour No Operation). Résultat pas de popup, et j'ai une licence validé sans clé.


Bonne vacances et à l'année pro inshallah brother




