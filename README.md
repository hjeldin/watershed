Watershed Segmentation for White Matter Extraction
=========

Estrazione di Bateria Bianca tramite l'algoritmo Watershed.

Brief:
L'algoritmo watershed, come per tutti gli algoritmi inerenti la segmentazione di immagini, risulta essere di diffcile implementazione. I problemi di sovrasegmentazione da un lato, e quelle di sottosegmentazione dall'altro rendono molto importante la fase di pre-processing e di pre-segmentazione per rendere efficace la trasformazione. In queste fasi risultano essere decisive le variabili in gioco, quale ad esempio il raggio da scegliere per l'elemento strutturante. Sta quindi alla sensibilitá del programmatore adattare a diverse immagini il tipo e il valore delle variabili, in modo da raggiungere il risultato migliore.

La variante illustrata evidenzia come talvolta soluzioni semplici possono essere comunque efficaci, anche se in modo grezzo. La segmentazione di immagini puó quindi, in determinati casi, venire implementata solo attraverso l'utilizzo di operazioni morfologiche che agiscano sull'intensitá dell'immagine, evidenziandone le parti desiderate. Il tutto puó essere ricondotto ad una trasformazione che fa uso di thresholding histogram-based.