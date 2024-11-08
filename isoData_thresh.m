function isoData_thresh = isoData_thresh(image)

image_lin = image(:);
epst = 0.01;
t = mean(image_lin);
res = 1;

while res>epst
    meanL = mean(image_lin(image_lin<t));
    meanH = mean(image_lin(image_lin>t));
    isoData_thresh = (meanL+ meanH)./2;

    epst = abs(isoData_thresh - t);
    t = isoData_thresh;
end
end