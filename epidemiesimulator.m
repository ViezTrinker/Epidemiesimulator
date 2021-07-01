clear,clc

anzpunkte=500; %Anzahl Menschen
weite=100; %Raumweite
pos=weite*rand(2,anzpunkte);
maxtage=2000; % Anzahl Tage
zustand=zeros(maxtage,anzpunkte); % 0:ansteckbar, 1:infiziert, 2:immun, 3:tot
krankdauer=14; %Krankheitsdauer
mortrate=0.01; %Todeswahrscheinlichkeit
immundauer=7; %Dauer der Immunität
zustand(1:krankdauer,1)=1;
zustand(krankdauer+1:krankdauer+1+immundauer,1)=2;
bewradius=2.47; %Bewegungsradius
infradius=sqrt(2/pi)*5; %Infektionsradius

figure(1),clf


for tage=1:maxtage
    
    if tage>1
    pos(:,idxntot)=pos(:,idxntot)+2*bewradius*rand(2,anzpunkte-anztot(tage-1))-bewradius;
    else
        pos=pos+2*bewradius*rand(2,anzpunkte)-bewradius;
    end
    pos(pos>weite)=pos(pos>weite)-weite;
    pos(pos<0)=weite+pos(pos<0);
    
    for m=1:anzpunkte
        for n=1:anzpunkte
            if m==n
                dist(m,n)=10*weite;
                continue;
            end
            dist(m,n)=sqrt( ( pos(1,m)-pos(1,n) )^2 + ( pos(2,m)-pos(2,n) )^2 );
            
            if dist(m,n)<=infradius && (zustand(tage,m)==1 || zustand(tage,n)==1 )
                
                if zustand(tage,m)==0
                    zustand(tage+1:tage+krankdauer,m)=1;
                    if rand(1)>mortrate
                    zustand(tage+krankdauer+1:tage+krankdauer+1+immundauer,m)=2;
                    else
                        zustand(tage+krankdauer+1:maxtage,m)=3;
                    end
                end
                
                if zustand(tage,n)==0
                    zustand(tage+1:tage+krankdauer,n)=1;
                    if rand(1)>mortrate
                    zustand(tage+krankdauer+1:tage+krankdauer+1+immundauer,n)=2;
                    else
                        zustand(tage+krankdauer+1:maxtage,n)=3;
                    end
                end
            end
        end
    end
    
    posges=pos(:,zustand(tage,:)==0);
    posinf=pos(:,zustand(tage,:)==1);
    posgen=pos(:,zustand(tage,:)==2);
    postot=pos(:,zustand(tage,:)==3);
    idxntot=find(zustand(tage,:)~=3);
    
    [x, anzinf(tage)]=size(posinf);
    [x, anzges(tage)]=size(posges);
    [x, anzgen(tage)]=size(posgen);
    [x, anztot(tage)]=size(postot);
    
    plot(posges(1,:),posges(2,:),'go', posinf(1,:),posinf(2,:),'r*', posgen(1,:),posgen(2,:),'bs', postot(1,:),postot(2,:),'kx'), 
    title(['Tag: ' num2str(tage)])
    pause(0.01)
    
    if anzinf(tage)==0
        legend('Ansteckbare','Infizierte','Immune','Tote')
        break
    end
end
legend('Ansteckbare','Infizierte','Immune','Tote')
anz=([anzinf;anzges;anzgen;anztot]/anzpunkte*100)';
figure(2),clf
bar(anz,'stacked'), legend('Infizierte', 'Ansteckbare', 'Immune', 'Tote'), xlabel('Tage'), 
ylabel('Anteil der Population in %'), ylim([0 100])