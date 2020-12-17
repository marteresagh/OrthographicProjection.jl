# Description
In this package you can find two main algorithms:
 - *segment* : allows you to separate the points of a 3D point cloud contained in a volume,
 - *orthophoto* : generates the image as orthographic projection of 3D point cloud with respect to a chosen plane

Both of them has the same **core function**, that takes as input a [point cloud Potree project](https://github.com/potree/potree) and a [cuboidal LAR model](https://github.com/cvdlab/LinearAlgebraicRepresentation.jl).

## Input Point Cloud
To manage a point cloud with huge number of points we use Potree project, achieved with the tool [PotreeConverter 1.7](https://github.com/potree/PotreeConverter/tree/master).

### Potree
A Potree is a data structure used to store huge point clouds, based on octree. All details of this structure are described by Markus Schütz in his [thesis](https://www.cg.tuwien.ac.at/research/publications/2016/SCHUETZ-2016-POT/SCHUETZ-2016-POT-thesis.pdf).

![potree](./images/Octree.jpg)

A Potree project is a collection of files, for each node of the octree there is a file called r, followed by a numeric code indicating its position in the hierarchy, for example:
 - r is the root node,
 - r0 is the first child of the root node,
 - r07 is the eighth child of the first child of the root node.

Due to particular way of tagging nodes, it is possible store Potree in a trie data structure, provided by Julia in module `DataStructures.jl`. As the usual tree data structure, a trie is made up of collections of trie node. Every trie node has three components:
- a value, where store information: in our case the path to the (LAS or LAZ) file associated;
- a map, where key is a digit and the value is trie node, used to establish the parent-child relationship;
- boolean value, indicating the end of word.

## Core Function: Trie Traversal
TODO : alla base di questi algortimi c'è la necessità di controllare quali punti ricadono nella regione di interesse. Per evitare di fare il controllo su tutti i punti della nuvola che rallenterebbe la procedura e avrebbe un costo computazionale elevato, ci facciamo guidare dalla struttura potree.
Ogni nodo dell'albero è generato dalla decomposizione dello spazio in regioni congruenti: il volume occupato dal nodo è descritto come un AABB, che troviamo nell'header del file associato al nodo.
A questo punto possiamo passare al controllo dell'intersezione tra l'octree e il volume di clipping.
Abbiamo come output tre valori:
 - 0 :  spiegare il significato
 - 1 :
 - 2 :  


FOTO e PSEUDO codice
## Segment
TODO:
quindi spieghi se la nuvola entra in tutto il volume processerò ogni punto altrimenti processerò solo i punti che ricadono nel volume ecc...
 salvataggio dei punti che ricadono nel modello

## Create image
TODO : l'immagine creata è un tensore che descrive i 3 canali rgb. inizialmente il tensore viene riempito del colore di fondo. descrivi Xref e Yref e che quindi di ogni punto che processo devo prendere il colore ed inserirlo nella giusta casella della matrice. e salvo poi in uno z buffer il valore z del punto.

se in quella casella comparirà un nuovo punto prenderò il pixel più vicino all'osservatore.
