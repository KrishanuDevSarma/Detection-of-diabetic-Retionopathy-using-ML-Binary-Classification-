%Project Stage-I
%Submitted By:
%Krishanu Dev Sarma(ECB18006)
%Himangshu Sarma(ECB18014)
%Sanjana Singha(ECB18023)

%Accessing the Diabetic Retinopathy Fundus Image Dataset

imdsT = imageDatastore('G:\Project Stage-I\Diaretdb1\diaretdb1_v_1_1\resources\images\ddb1_fundusimages','IncludeSubfolders',true,'FileExtensions',[".png"],'LabelSource', 'foldernames')
T = countEachLabel(imdsT);

for Idx = 1:89
       
%**********************Preprocessing****************************

	%Storing the Image in a variable
        im = readimage(imdsT,Idx);

	%Green Channel extraction
        green = im(:,:,2);
 
    %Applying CLAHE(Contrast Limited Adaptive Histogram)           
    adhist=adapthisteq(green,'clipLimit',0.02,'Distribution','uniform');
end;