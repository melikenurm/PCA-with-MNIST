
clear all;
dataset=importdata('C:\Users\Melike Nur Mermer\Desktop\PCA\PCA\sayi.dat');
[sample,feature]=size(dataset);
for i=1:sample
    for j=1:feature-1
    x(i,j)=dataset(i,j);
    end
    y(i,1)=dataset(i,feature);
end
nofclass=max(y)+1;
a=1;
for i=1:nofclass
nofclasssample=0;
        for k=1:sample
        if y(k,1)==(i-1)
            traindatax(a,:)=x(k,:);
            traindatay(a,1)=y(k,1);
            a=a+1;
            nofclasssample=nofclasssample+1;
        end
        if nofclasssample==5
            break;
        end
        end
end

a=1;
for i=1:sample
var=0;
    for j=1:50
        if x(i,:)==traindatax(j,:)
           var=1;
           break;
        end
    end
    if var==0
           testdatax(a,:)=x(i,:);
           testdatay(a,1)=y(i,:);
           a=a+1;
    end
end
%train örneklerini sütunlar haline getir
trainx=transpose(traindatax);
averages(:,1)=mean(trainx.');
%hesaplanan ortalamadan mean centered samplelar elde edilir
for i=1:50
    mcs(:,i)=trainx(:,i)-averages(:,1);%mean centered sample
end
mcst=transpose(mcs);
%covariance matrix hesaplanýr
cov=mcs*mcst;
%eigenvalue-eigenvectorler hesaplanýr
eval=eig(cov);%eigenvaluelar ve eigenvectorler sýralý geliyor
[evect,v]=eig(cov);
evect=transpose(evect);
efaces=evect*mcs;
%64 tanenin 11 tanesi "0"
%ilk %40 evale karþýlýk gelen
for i=1:53*0.4
    emat4(i,:)=efaces(i,:);
end
%ilk %60 evale karþýlýk gelen
for i=1:53*0.6
    emat6(i,:)=efaces(i,:);
end
%ilk %80 evale karþýlýk gelen
for i=1:floor(53*0.8)
    emat8(i,:)=efaces(i,:);
end

%eðitim bitti bu örneklere olan benzerliðine bakýlarak test yapýlýr
testx=transpose(testdatax);
for i=1:length(testx)
mctestx(:,i)=testx(:,i)-averages(:,1);
end
efacetestx=evect*mctestx;

%test datalarýnýn train datalarýna olan uzaklýklarýný tutan matris
distances=zeros(length(testdatax),50);
for i=1:length(testdatax)
    for k=1:50
    dist=0;
    for j=1:21
        dist=dist+(efacetestx(j,i)-emat4(j,k))^2;
    end
    distances(i,k)=dist^(1/2);
    end
end
correct=0;
for i=1:length(testdatax)
[m,nearest(i,1)]=min(distances(i,:));
predictions(i,1)=traindatay(nearest(i,1),1);
end
nofcp=zeros(10,1);%number of correct predictions
confmat=zeros(10,10);%karýþýklýk matrisi
crt=[];%doðru tahmin edilen örnekler 1, yanlýþlar 0
for j=1:10
    for i=1:length(testdatax)
        if predictions(i,1)==j-1 && predictions(i,1)==testdatay(i,1)
        nofcp(j,1)=nofcp(j,1)+1;
        crt(i)=1;
        end
    end
end
correct=sum(nofcp);

for i=1:length(testdatax)
    realvalue=testdatay(i,1)+1;
    for j=1:10
        if predictions(i,1)==j-1
            confmat(realvalue,j)=confmat(realvalue,j)+1;
        end
    end
end
for i=1:10
    for j=1:10
        confmat2(i,j)=confmat(i,j)/sum(confmat(i,:));
    end
end
%örnek tahmin resimleri
for i=1:8
    for j=1:8
        mat1(i,j)=testdatax(3679,8*(i-1)+j);
    end
end
im1=mat2gray(mat1);
imshow(im1);