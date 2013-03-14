clc; clear; close all;

p = imread('data/pere.png');

% Converte l'immagine in scala di grigi
I = rgb2gray(p);
subplot(231); imshow(I,[]), title('Original image')

% crea un filtro bidimensionale hy esaltando con l'opzione 
% 'sobel' i bordi orizzontali dell'immagine. (estrazione della variazione dell'intensità)
hy = fspecial('sobel');

% hx è la matrice trasposta hy: esalta i bordi verticali 
% dell'immagine
hx = hy';

% esaltiamo i bordi orizzontali e verticali in due matrici distinte Iy e Ix
% filtra l'array multidimensionale double(I) con il filtro hy 
Iy = imfilter(double(I), hy, 'replicate');
% filtra l'array multidimensionale double(I) con il filtro hx 
Ix = imfilter(double(I), hx, 'replicate');

% estrae l'immagine gradiente dalle immagini filtrate. ogni punto è la 
% magnitudine della variazione di intensità
gradmag = sqrt(Ix.^2 + Iy.^2);
subplot(232); imshow(gradmag,[]), title('Gradient magnitude (gradmag)')

% crea l'elemento morfologico strutturante di forma discoidale 
% di raggio 20
se = strel('disk', 20);

% esegue l'apertura morfologica dell'immagine tramite l'elemento
% morfologico strutturante.
% 'imopen' comprende l'operazione di erosione e dilatazione.
Io = imopen(I, se);

% esegue l'erosione morfologica dell'immagine tramite l'elemento
% morfologico strutturante.
Ie = imerode(I, se);

% effettua la ricostruzione morfologica dell'immagine Ie, attraverso la
% maschera I (immagine in scala di grigi)
Iobr = imreconstruct(Ie, I);
subplot(233); imshow(Iobr), title('Apertura attraverso ricostruzione (Iobr)')

% dilata l'immagine Iobr usando l'elemento morfologico 'se' (forma discoidale)
Iobrd = imdilate(Iobr, se);
subplot(232); imshow(Iobrd); title('Apertura ricostruita dilatata');

% ricostruisce l'immagine tramite i rispettivi complementi delle elaborazioni  
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));

% esegue il nuovamente il complemento per restituire l'immagine con i
% massimi regionali corretti
Iobrcbr = imcomplement(Iobrcbr);
subplot(234); imshow(Iobrcbr), title('Apertura-chiusura attraverso la ricostruzione (Iobrcbr)')

% estrae i massimi regionali 
fgm = imregionalmax(Iobrcbr);
subplot(235); imshow(fgm), title('Massimi regionali di apertura-chiusura attraverso ricostruzione (fgm)')

I2 = I;
% i massimi vengono sovraimposti all'immagine I2
I2(fgm) = 255;
subplot(236); imshow(I2), title('Massimi regionali sovraimposti sulla immagine originale(I2)')

% creazione dell'elemento strutturante se2
se2 = strel(ones(5,5));

% dilatazione dei massimi per evitare frammentazione dei marker
fgm2 = imclose(fgm, se2);
fgm3 = imerode(fgm2, se2);
% rimuove dall'immagine i marker più piccoli di 20 pixel
fgm4 = bwareaopen(fgm3, 20);

I3 = I;
% i massimi ora corretti vengono sovraimposti all'immagine I3
I3(fgm4) = 255;
figure; subplot(231); imshow(I3), title('Massimi regionali modificati sovraimopsti alla immagine originale(fgm4)')

% graytresh: rende binaria l'immagine Iobrcbr tramite la funzione greytresh
bw = im2bw(Iobrcbr, graythresh(Iobrcbr));
subplot(232); imshow(bw), title('Thresholded opening-closing by reconstruction (bw)');

% per ogni pixel calcola la sua distanza dal più vicino valore non zero
D = bwdist(bw);
% estrae lo scheletro delle zone di influenza degli oggetti in primo piano.
% serve a limitare l'espansione dell'algoritmo di watershed al passo
% successivo.
DL = watershed(D);

% background markers
bgm = DL == 0;
subplot(233); imshow(bgm), title('Watershed ridge lines (bgm)')

% quelli che prima erano i massimi regionali ora sono i minimi: a ciò viene
% associato lo scheletro delle zone d'influenza.
gradmag2 = imimposemin(gradmag, bgm | fgm4);
subplot(233);imshow(gradmag2),title('gradmag2s')
%subplot(233);imshow(gradmag,[]),title('gradmag')

% esegue l'algoritmo watershed per estrarre i contorni definitivi dei
% marker
L = watershed(gradmag2);
subplot(233);imshow(label2rgb(L)),title('watershed');
I4 = I;

% ricalca i contorni degli oggetti in primo piano
I4(imdilate(L == 0, ones(3, 3)) | bgm | fgm4) = 255;
subplot(234), imshow(I4), title('Markers and object boundaries superimposed on original image (I4)')

% le regioni vengono colorate 
Lrgb = label2rgb(L, 'jet', 'w', 'shuffle');
subplot(235), imshow(Lrgb)
title('Colored watershed label matrix (Lrgb)')

subplot(236), imshow(I), hold on
himage = imshow(Lrgb);
% il canale alfa permette di rendere trasparente le tonalità di colore 
% dell'immagine Lrgb
set(himage, 'AlphaData', 0.3);
title('Lrgb superimposed transparently on original image')