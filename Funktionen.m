clear
clc

autos = generiere_autos_neu(1000)
[spur1, spur2, spur3, spur4, spur5, spur6, spur7] = spuren_aus_autos(autos);
%alle_spuren = [spur1; spur2; spur3; spur4; spur5; spur6; spur7]
%disp('Spur 1:')
spur1
a = size(spur1)
b = size(spur2)
c = size(spur3)
d = size(spur4)
e = size(spur5)
f = size(spur6)
g = size(spur7)

spur1
autos_auf_spur1 = 0
[autos_auf_spur1, spur1] = autos_auf_spur_generieren(spur1, 50, autos_auf_spur1);
autos_auf_spur1
spur1

[autos_auf_spur1, spur1] = autos_auf_spur_generieren(spur1, 80, autos_auf_spur1);
autos_auf_spur1
spur1

[autos_auf_spur1, spur1] = autos_auf_spur_generieren(spur1, 250, autos_auf_spur1);
autos_auf_spur1
spur1

[autos_auf_spur1, spur1] = autos_auf_spur_generieren(spur1, 500, autos_auf_spur1);
autos_auf_spur1
spur1

autos_auf_spur = 15;
counter_alt = 20;
endzeiten2 = 0
[anz_autos, autos_auf_spur, counter, counter_alt, endzeiten2] = generiere_gruenphase(2, 28, autos_auf_spur, counter_alt, 130, endzeiten2)

[autos_auf_spur, spur2] = autos_auf_spur_generieren(spur2, 220, autos_auf_spur);

[anz_autos, autos_auf_spur, counter_neu, counter_alt, endzeiten2] = generiere_gruenphase(2, 20, autos_auf_spur, counter, 220, endzeiten2)

%Folgende Funktion generiert Autos, sodass ein zweidimensionales Array
%erstellt wird, in der ersten Zeile sind die Spuren, in der zweiten die
%Zeiten, zu der das Auto in der Simulation erscheint
function autos_neu_fkt = generiere_autos_neu(N)
    zeiten_fkt = zeros(1,N); %Platzhalter für Spawnzeiten
    for i=1:N
        zeiten_fkt(i) = i + randn();
    end

    wahrscheinlichkeiten = [0.05, 0.35, 0.07, 0.25, 0.07, 0.11, 0.15];
    spuren_werte = [1, 2, 3, 4, 5, 6, 7]; % Die entsprechenden Werte

    kumulative_wahrscheinlichkeiten = cumsum(wahrscheinlichkeiten);

    zufaellige_nummer = rand(1, N); % N Zufallszahlen zwischen 0 und 1
    spuren = zeros(1, N); % Platzhalter für die Spuren

    % Werte basierend auf Wahrscheinlichkeiten zuweisen
    for i = 1:N
        spuren(i) = spuren_werte(find(zufaellige_nummer(i) <= kumulative_wahrscheinlichkeiten, 1));
    end

    zeiten_fkt = sort(zeiten_fkt);

    autos_neu_fkt = [spuren; zeiten_fkt];
end

%Folgende Funktion transformiert ein zweidimensionales Array mit erster
%Zeile Spuren und zweiter Zeile Spaynzeiten in sieben einzelne Arrays (ein
%Array für jede Spur), bei der in jedem Array die Spawnzeiten für die
%jeweilige Spur stehen
function [spur1, spur2, spur3, spur4, spur5, spur6, spur7] = spuren_aus_autos(autos)
    counter1 = 1; counter2 = 1; counter3 = 1; counter4 = 1; counter5 = 1; counter6 = 1; counter7 = 1;
    spur1 = zeros(length(autos(1)));
    spur2 = zeros(length(autos(1)));
    spur3 = zeros(length(autos(1)));
    spur4 = zeros(length(autos(1)));
    spur5 = zeros(length(autos(1)));
    spur6 = zeros(length(autos(1)));
    spur7 = zeros(length(autos(1)));
    for i = 1:length(autos)
        switch(autos(1,i))
            case 1
                spur1(counter1) = autos(2,i);
                counter1 = counter1 + 1;
            case 2
                spur2(counter2) = autos(2,i);
                counter2 = counter2 + 1;
            case 3
                spur3(counter3) = autos(2,i);
                counter3 = counter3 + 1;
            case 4
                spur4(counter4) = autos(2,i);
                counter4 = counter4 + 1;
            case 5
                spur5(counter5) = autos(2,i);
                counter5 = counter5 + 1;
            case 6
                spur6(counter6) = autos(2,i);
                counter6 = counter6 + 1;
            case 7
                spur7(counter7) = autos(2,i);
                counter7 = counter7 + 1;
            otherwise
                disp('Delete RL!');
        end
    end
end

%Folgende Funktion generiert Autos (autos_auf_spur_fkt) zur Zeit timer mit
%...
function [autos_auf_spur_fkt, spur_autos] = autos_auf_spur_generieren(spur_autos, timer, autos_auf_spur_fkt)
    for i = 1:length(spur_autos)
        if (spur_autos(i) < timer && spur_autos(i) ~= 0)
            autos_auf_spur_fkt = autos_auf_spur_fkt + 1;
            spur_autos(i) = 0;
        end
    end
end

%Funktion generiere_gruenphase: Wie viele Autos schaffen es in der Gruenphase
%Variablen der folgenden Funktion: (y) anz_autos: schaffen ueber gruen, autos_auf_spur(y): verbleiben
%counter_neu: aktualisierter Counter Autos über Spur, alt: nicht aktualisiert
%Var (u): spur: Zahl 1 - 7, laenge: Zeit in s, counter_alt: Autos bisher
%über Ampel, start_timer_fkt: Startzeit insgesamt, endzeiten: Zeiten, zu
%denen Autos die Kreuzung überqueren
function [anz_autos_fkt, autos_auf_spur_fkt, counter_neu_fkt, counter_alt, endzeiten] = generiere_gruenphase(spur, laenge, autos_auf_spur_u, counter_alt_u, start_timer_fkt, endzeiten) 
    if (spur == 2 || spur == 4)  
        if laenge < 8.9
            anz_autos_fkt = round(0.314739 * power(laenge, 1.2629099));
            %endzeiten = (1, anz_autos_fkt);
            for i = 1:min([anz_autos_fkt,autos_auf_spur_u])
                endzeiten(counter_alt_u + i) = start_timer_fkt + nthroot((i / 0.314739), 1.2629099);
            end
        elseif laenge >= 8.9
            anz_autos_fkt = round((laenge - 8.9) / 1.4 + 5);
            %endzeiten = (1, anz_autos_fkt);
            for i = 1:min([anz_autos_fkt,autos_auf_spur_u])
                if i <= 5
                    endzeiten(counter_alt_u + i) = start_timer_fkt + nthroot((i / 0.314739), 1.2629099);
                else
                    endzeiten(counter_alt_u + i) = start_timer_fkt + 8.9 + (i - 5) * 1.5;
                end
            end
        end

    elseif (spur == 1 || spur == 3 || spur == 5 || spur == 6 || spur == 7)
        if laenge < 8.3
            anz_autos_fkt = round(0.3507674 * power(laenge, 1.2576509));
            %endzeiten = (1, anz_autos_fkt);
            for i = 1:min([anz_autos_fkt,autos_auf_spur_u])
                endzeiten(counter_alt_u + i) = start_timer_fkt + nthroot((i / 0.3507674), 1.2576509);
            end

        elseif laenge >= 8.3
            anz_autos_fkt = round((laenge - 8.3) / 1.4 + 5);
            %endzeiten = (1, anz_autos_fkt);
            for i = 1:min([anz_autos_fkt,autos_auf_spur_u])
                if i<= 5
                    endzeiten(counter_alt_u + i) = start_timer_fkt + nthroot((i / 0.3507674), 1.2576509);
                else
                    endzeiten(counter_alt_u + i) = start_timer_fkt + 8.3 +(i - 5) * 1.4;
                end
            end

        end
        
    end
    autos_auf_spur_fkt = autos_auf_spur_u - anz_autos_fkt;
    if autos_auf_spur_fkt < 0
        autos_auf_spur_fkt = 0;
    end
    counter_alt = counter_alt_u;
    counter_neu_fkt = counter_alt_u + autos_auf_spur_u - autos_auf_spur_fkt;
end