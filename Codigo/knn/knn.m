
%Abrir imagen
A=zeros(30,5);
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
%X=[1 1 1 1 1 1 4 4 4 4 4 3 3 3 3 3 2 2 2 2 2];
X=[1 1 1 1 1 1 1 1 4 4 4 4 4 4 4 3 3 3 3 3 3 3 2 2 2 2 2 2 2 2];
A(:,5)=X.';


%%

P=zeros(1,4);
name=('4.jpeg');
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
H=A;
arand=0;
clavo=0;
torn=0;
tuer=0;


 for i=1:30
     dist(i,1)=sqrt((H(i,1)-P(1,1))^2+(H(i,2)-P(1,2))^2+(H(i,3)-P(1,3))^2+(H(i,4)-P(1,4))^2);
     dist(i,2)=H(i,5);
 end
    
    [~, s] = sort(dist(:, 1));
    dist=dist(s, :);
    k=3;
    %k=input('Ingrese el valor de k');
    for i=1:k
        if dist(k,2)==1
            arand=+1;
        end
        if dist(k,2)==2
            tuer=+1;
        end
        if dist(k,2)==3
            torn=+1;
        end
        if dist(k,2)==4
            clavo=+1;
        end
    end
     if arand>tuer && arand>torn && arand>clavo
        disp('La imagen analizada es:'); disp(name);
         disp('El objeto es una arandela');
     end
     if tuer>arand && tuer>torn && tuer>clavo
         disp('La imagen analizada es:'); disp(name);
         disp('El objeto es una tuerca');
     end
     if torn>tuer && torn>arand && torn>clavo
         disp('La imagen analizada es:'); disp(name);
         disp('El objeto es un tornillo');
     end
     if clavo>tuer && clavo>torn && clavo>arand
         disp('La imagen analizada es:'); disp(name);
         disp('El objeto es un clavo');
     end
  