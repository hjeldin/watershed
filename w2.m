close all;
clc;
clear;
A = imread('data\256_MRI_z_109.png');
subplot(221); imshow(A); title('Immagine di partenza');

% effetua denoising dell'immagine tramite median filtering a [2,2]
A = medfilt2(A,[2,2]);

% crea l'elemento morfologico strutturante
se = strel('disk',5);

% applica il filtering sull'immagine tramite disk di dimensione 5.
% imtophat esegue l'apertura morfologica e sottrae il risultato
% dall'immagine originale
imc = imtophat(A,se);
% applica il filtering sull'immagine tramite disk di dim. 5
% imbothat esegue la chiusura morfologica e sottrae il risultato
% dall'immagine originale
ima = imbothat(A,se);

% eseguo il miglioramento del contrasto dell'immagine tramite top-hat e
% bottom-hat filtering
Ienh = imsubtract(imadd(imc,A),ima);

% estraggo l'immagine complementare
ic = imcomplement(Ienh);

% la funzione seguente serve ad estrarre i minimi regionali dall'immagine
% 60 e' il valore minimo delle valli.
iem = imextendedmin(ic, 60);

% impongo i minimi sull'immagine originale
iimp = imimposemin(ic,iem);
iimp = imcomplement(iimp);
subplot(222); imshow(Ienh); title('Immagine a contrasto migliorato');

Lrgb = label2rgb(iem, 'jet', 'k', 'shuffle');
subplot(223), imshow(Lrgb), title('Valli evidenziate da imextendedmin()')

subplot(224), imshow(A), hold on
himage = imshow(Lrgb);

% il canale alfa permette di rendere trasparente le tonalità di colore 
% dell'immagine Lrgb
set(himage, 'AlphaData', 0.2);
title('Immagine Lrgb sovraimposta \newline trasparentemente alla immagine originale')
