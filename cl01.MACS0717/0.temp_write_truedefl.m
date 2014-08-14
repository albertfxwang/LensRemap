
sys= '14';
num=2;
img=[sys '.' num2str(num)];
ra=109.37966;
dec=37.739664;
rad=12;
alpha_1=rand((rad*2)^2,1);
alpha_2=rand((rad*2)^2,1);
alpha=[alpha_1 alpha_2];

fid=fopen('14.2_truedefl.dat','wt');
fprintf(fid,'#-------------------------------------------------------------------------------\n');
fprintf(fid,'# RA\t\t DEC\t\n');
fprintf(fid,'%12.7f\t %12.7f\n',ra,dec);
fprintf(fid,'#-------------------------------------------------------------------------------\n');
fprintf(fid,'# alpha_1,true\t alpha_2,true\n');
fprintf(fid,'%12.7f\t %12.7f\n',alpha');
fclose(fid);
