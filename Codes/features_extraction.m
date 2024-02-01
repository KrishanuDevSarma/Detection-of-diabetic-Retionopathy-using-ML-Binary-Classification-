
%********************Feature Extraction******************************
      
%%Extracting LBP Features from the Images
        img=imresize(adhist,[256 256]);
     
        sum=0;g=0;
        for i= 2:255
            for j=2:255
                sum=0;
                if(img(i-1,j-1)<img(i,j))
                    g=0;
                else
                    g=1;
                end;
                sum = sum + g*(2^0);
                if(img(i-1,j)<img(i,j))
                    g=0;
                else
                    g=1;
                end;
                sum = sum + g*(2^1);
                if(img(i-1,j+1)<img(i,j))
                    g=0;
                else
                    g=1;
                end;
                sum = sum + g*(2^2);
                if(img(i,j+1)<img(i,j))
                    g=0;
                else
                    g=1;
                end;
                sum = sum + g*(2^3);
                if(img(i+1,j+1)<img(i,j))
                    g=0;
                else
                    g=1;
                end;
                sum = sum + g*(2^4);
                if(img(i+1,j)<img(i,j))
                    g=0;
                else
                    g=1;
                end;
                sum = sum + g*(2^5);
                if(img(i+1,j-1)<img(i,j))
                    g=0;
                else
                    g=1;
                sum = sum + g*(2^6);
                end;
                if(img(i,j-1)<img(i,j))
                    g=0;
                else
                    g=1;
                sum = sum + g*(2^7);
                end;
                img(i,j)=sum;
            end;
        end;  
        img(1, :) = []; % Delete rows.
        img(255, :) = []; % Delete rows.
        img(:, 1) = []; % Delete columns.
        img(:, 255) = []; % Delete columns.
        
        h1=imhist(img);
        h2=h1'./256;
	  
%Storing the Histograms of the Images in an Array
        ArrayOfLBPImages{Idx}= h2;
 
end;

%Compiling the Histograms of all the Images in a Matrix  
Features=cell2mat(ArrayOfLBPImages);

%%Extracting GLCM Features from the Images 
for Idx = 1:89
       
        im = readimage(imdsT,Idx);
 
        green = im(:,:,2);
        adhist=adapthisteq(green,'clipLimit',0.02,'Distribution','uniform');
                     
        glcms = graycomatrix(adhist);
        R = sum(glcms,'all');
        normalized_glcms = glcms./R;
        homogeneity = 0;
        contrast = 0;
        energy = 0; correlation = 0;
        mean_glcms = 0;
        var_glcms = 0;
        for i = 1:8
            for j = 1 : 8

%Detecting the value of Homogeneity feature
                homogeneity = homogeneity + (normalized_glcms(i,j)/(1 + (i-j)^2));

%Detecting the value of Contrast feature
                contrast = contrast + (normalized_glcms(i,j)*(i-j)^2);

%Detecting the value of Energy feature
                energy = energy + normalized_glcms(i,j)^2;
                mean_glcms = mean_glcms + i*normalized_glcms(i,j);
 
            end
        end
 
        for i = 1:8
            for j = 1:8
                var_glcms = var_glcms + (normalized_glcms(i,j)*(i-mean_glcms)^2);
            end
        end
 
        for i = 1:8
            for j = 1:8

%Detecting the value of Correlation feature
                correlation = correlation + ((normalized_glcms(i,j)*(i-mean_glcms)*(j - mean_glcms))/var_glcms);
            end
        end
        feature(:,Idx) = [homogeneity;correlation;contrast;energy]
end

%Storing the combined GLCM Features of all the Images as a single matrix 
GLCM_feature = feature.';
