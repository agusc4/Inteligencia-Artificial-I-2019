%Abrir imagen
A=zeros(30,4);
B=dir('*.jpeg');
mi=zeros(size(B));
ma=zeros(size(B));
ex=zeros(size(B));
hu=zeros(30,2);
sum1=0;
sum2=0;
sum3=0;
sum4=0;
d=[0 0 0 0];

for i=1:size(B,1)
   I= imread(B(i).name);
   %I=imread('prueba.jpeg');
   
   %% filtrado en rojo, azul, amarillo
   rmat=I(:,:,1);
   gmat=I(:,:,2);
   bmat=I(:,:,3);
   lvr=0.58;
   lvv=0.56;
   lva=0.56;
   i1=im2bw(rmat,lvr);
   i2=im2bw(gmat,lvv);
   i3=im2bw(bmat,lva);
   Isum=(i1&i2&i3);
    %{
    subplot (2,2,1), imshow(i1);
    title('Rojos');
    subplot (2,2,2), imshow(i2);
    title('Verdes');
    subplot (2,2,3), imshow(i3);
    title('Azules');
    subplot (2,2,4), imshow(Isum);
    title('suma'); 
%}
  %% Completar la imagen y rellenar
    Icomp=imcomplement(i1);
    Ifilled =imfill(Icomp, 'holes');
    %figure; imshow(Ifilled);

    %% Forma de disco
    se=strel ('disk',1);
    Iop=imopen(Ifilled,se);
    %figure;
    %imshow(Iop);
    %% eliminar obj ruido
    BW2 = bwpropfilt(Iop,'perimeter',1); 
    %figure; 
    %imshow(BW2);
    %title('Objects with the Largest Perimeters')
    [tag,~]=bwlabel(BW2,4);
    %imshow(tag);
    stats=regionprops(tag,'Eccentricity','Area','MajorAxisLength','MinorAxisLength','Perimeter');
    perimetro=[stats.Perimeter];
    area= [stats.Area];
    ma(i)=[stats.MajorAxisLength];
    mi(i)=[stats.MinorAxisLength];
    ex(i)=[stats.Eccentricity];
    A(i,1)=ex(i);
    A(i,2)=ma(i)/mi(i);
    hu(i,:)=hu_moment(tag);
    A(i,3)=hu(i,1);
    A(i,4)=hu(i,2);
end


%% Km

Acls=zeros(1,26);
R=zeros(4,4);
R(1,1)=0.98; %tornillo
R(1,2)=5;
R(1,3)=0.5;
R(1,4)=0.3;
R(2,1)=0.435; %tuerca
R(2,2)=1.1;
R(2,3)=0.1601;
R(2,4)=0.0015;
R(3,1)=0.15; %arandela
R(3,2)=1;
R(3,3)=0.159;
R(3,4)=0.000008;
R(4,1)=0.99; %clavo
R(4,2)=15;
R(4,3)=1.4;
R(4,4)=2;
for j=1:4
aux1=0;
aux2=0;
aux3=0;
aux4=0;
    for i=1:30
            d(1)=sqrt((A(i,1)-R(1,1))^2+(A(i,2)-R(1,2))^2+(A(i,3)-R(1,3))^2+(A(i,4)-R(1,4))^2); %distancia al primer punto
            d(2)=sqrt((A(i,1)-R(2,1))^2+(A(i,2)-R(2,2))^2+(A(i,3)-R(2,3))^2+(A(i,4)-R(2,4))^2); %distancia al segundo punto
            d(3)=sqrt((A(i,1)-R(3,1))^2+(A(i,2)-R(3,2))^2+(A(i,3)-R(3,3))^2+(A(i,4)-R(3,4))^2); %distancia al tercer punto
            d(4)=sqrt((A(i,1)-R(4,1))^2+(A(i,2)-R(4,2))^2+(A(i,3)-R(4,3))^2+(A(i,4)-R(4,4))^2); %distancia al cuarto punto

            if d(1)<d(2) && d(1)<d(3) && d(1)<d(4) || d(1)==0 %tornillo
                aux1=aux1+1;
                dd1(aux1,1)=A(i,1); %matriz coordenadas (ex,div,fi1,fi2)
                dd1(aux1,2)=A(i,2);
                dd1(aux1,3)=A(i,3);
                dd1(aux1,4)=A(i,4);
                dd1(aux1,5)=3;
                Acls(1,i)=3;
            end
            if d(2)<d(1) && d(2)<d(3) && d(2)<d(4)|| d(2)==0 %tuerca
                aux2=aux2+1;
                dd2(aux2,1)=A(i,1); %matriz coordenadas (ex,div,fi1,fi2)
                dd2(aux2,2)=A(i,2);
                dd2(aux2,3)=A(i,3);
                dd2(aux2,4)=A(i,4);
                dd2(aux2,5)=2;
                Acls(1,i)=2;
            end
            if d(3)<d(2) && d(3)<d(1) && d(3)<d(4)|| d(3)==0 %arandela
                aux3=aux3+1;
                dd3(aux3,1)=A(i,1); %matriz coordenadas (ex,div,fi1,fi2)
                dd3(aux3,2)=A(i,2);
                dd3(aux3,3)=A(i,3);
                dd3(aux3,4)=A(i,4);
                dd3(aux3,5)=1;
                Acls(1,i)=1;
            end
            if d(4)<d(2) && d(4)<d(3) && d(4)<d(1)|| d(4)==0 %clavo
                aux4=aux4+1;
                dd4(aux4,1)=A(i,1); %matriz coordenadas (ex,div,fi1,fi2)
                dd4(aux4,2)=A(i,2);
                dd4(aux4,3)=A(i,3);
                dd4(aux4,4)=A(i,4);
                dd4(aux4,5)=4; 
                Acls(1,i)=4;
            end
    end
  
sum=zeros(4,4);    

 for t=1:aux1
     sum(1,1)=sum(1,1)+dd1(t,1);
     sum(1,2)=sum(1,2)+dd1(t,2);
     sum(1,3)=sum(1,3)+dd1(t,3);
     sum(1,4)=sum(1,4)+dd1(t,4);
 end
for t=1:aux2
     sum(2,1)=sum(2,1)+dd2(t,1);
     sum(2,2)=sum(2,2)+dd2(t,2);
     sum(2,3)=sum(2,3)+dd2(t,3);
     sum(2,4)=sum(2,4)+dd2(t,4);
end
 for t=1:aux3
     sum(3,1)=sum(3,1)+dd3(t,1);
     sum(3,2)=sum(3,2)+dd3(t,2);
     sum(3,3)=sum(3,3)+dd3(t,3);
     sum(3,4)=sum(3,4)+dd3(t,4);
 end
 for t=1:aux4
     sum(4,1)=sum(4,1)+dd4(t,1);
     sum(4,2)=sum(4,2)+dd4(t,2);
     sum(4,3)=sum(4,3)+dd4(t,3);
     sum(4,4)=sum(4,4)+dd4(t,4);
 end
 
 R(1,1)=sum(1,1)/aux1;
 R(2,1)=sum(2,1)/aux2;
 R(3,1)=sum(3,1)/aux3;
 R(4,1)=sum(4,1)/aux4;
 R(1,2)=sum(1,2)/aux1;
 R(2,2)=sum(2,2)/aux2;
 R(3,2)=sum(3,2)/aux3;
 R(4,2)=sum(4,2)/aux4;
 R(1,3)=sum(1,3)/aux1;
 R(2,3)=sum(2,3)/aux2;
 R(3,3)=sum(3,3)/aux3;
 R(4,3)=sum(4,3)/aux4;
 R(1,4)=sum(1,4)/aux1;
 R(2,4)=sum(2,4)/aux2;
 R(3,4)=sum(3,4)/aux3;
 R(4,4)=sum(4,4)/aux4;
 
 end
   figure;
   
    scatter(dd4(:,1),dd4(:,2),'r','filled');
    
    xlabel('Excentricidad');
    ylabel('max.ax/min.ax');
    hold on
    scatter(dd3(:,1),dd3(:,2),'m','filled');
    scatter(dd2(:,1),dd2(:,2),'b','filled');
    scatter(dd1(:,1),dd1(:,2),'g','filled');
    scatter(R(:,1),R(:,2),'filled','d','k');
    legend({'clavos','arandelas','tuercas','tornillos','centroides'});
    hold off
    
 figure;
    scatter(dd4(:,3),dd4(:,4),'r','filled');
    hold on
    scatter(dd3(:,3),dd3(:,4),'m','filled');
    scatter(dd2(:,3),dd2(:,4),'b','filled');
    scatter(dd1(:,3),dd1(:,4),'g','filled');
    scatter(R(:,3),R(:,4),'filled','d','k');
    legend({'clavos','arandelas','tuercas','tornillos','centroides'});
    xlabel('primer momento de Hu');
    ylabel('segundo momento de Hu');
    hold off
 
   %%
P=zeros(1,4);
name=('7.jpeg');
Ev=imread(name);
rmat2=Ev(:,:,1);
gmat2=Ev(:,:,2);
bmat2=Ev(:,:,3);
i1=im2bw(rmat2,lvr);
i2=im2bw(gmat2,lvv);
i3=im2bw(bmat2,lva);
Isum2=(i1&i2&i3);
Icomp2=imcomplement(Isum2);
Ifilled2 =imfill(Icomp2, 'holes');
se2=strel ('disk',1);
Iop2=imopen(Ifilled2,se2);
BW3 = bwpropfilt(Iop2,'perimeter',1);
%figure; imshow(BW3);
[tag2,nobj]=bwlabel(BW3,4);
stats2=regionprops(tag2,'Eccentricity','Area','MajorAxisLength','MinorAxisLength','Perimeter');
perimetro2=[stats2.Perimeter];
area2= [stats2.Area];
red2=4*pi*(area2/perimetro2^2);
ma2=[stats2.MajorAxisLength];
mi2=[stats2.MinorAxisLength];
hum=hu_moment(tag2);
P(1,1)=[stats2.Eccentricity];
P(1,2)=ma2/mi2 ;
P(1,3)=hum(1,1);
P(1,4)=hum(1,2);
dist=zeros(30,2);

            d(1)=sqrt((P(1,1)-R(1,1))^2+(P(1,2)-R(1,2))^2+(P(1,3)-R(1,3))^2+(P(1,4)-R(1,4))^2); %distancia al primer punto
            d(2)=sqrt((P(1,1)-R(2,1))^2+(P(1,2)-R(2,2))^2+(P(1,3)-R(2,3))^2+(P(1,4)-R(2,4))^2); %distancia al segundo punto
            d(3)=sqrt((P(1,1)-R(3,1))^2+(P(1,2)-R(3,2))^2+(P(1,3)-R(3,3))^2+(P(1,4)-R(3,4))^2); %distancia al tercer punto
            d(4)=sqrt((P(1,1)-R(4,1))^2+(P(1,2)-R(4,2))^2+(P(1,3)-R(4,3))^2+(P(1,4)-R(4,4))^2); %distancia al cuarto punto
            
 if d(1)<d(2) && d(1)<d(3) && d(1)<d(4) || d(1)==0 %tornillo
    disp('La imagen')
    disp(name),  
    disp('es un tornillo');   
 end
 if d(2)<d(1) && d(2)<d(3) && d(2)<d(4)|| d(2)==0 %tuerca
    disp('La imagen')
    disp(name),     
    disp('es una tuerca');         
 end
 if d(3)<d(2) && d(3)<d(1) && d(3)<d(4)|| d(3)==0 %arandela
    disp('La imagen')
    disp(name),       
    disp('es una arandela');      
end
if d(4)<d(2) && d(4)<d(3) && d(4)<d(1)|| d(4)==0 %clavo
    disp('La imagen')
    disp(name),
    disp('es un clavo');   
end
             
            
            
            