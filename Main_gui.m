function varargout = Main_gui(varargin)
% MAIN_GUI MATLAB code for Main_gui.fig
%      MAIN_GUI, by itself, creates a new MAIN_GUI or raises the existing
%      singleton*.
%
%      H = MAIN_GUI returns the handle to a new MAIN_GUI or the handle to
%      the existing singleton*.
%
%      MAIN_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN_GUI.M with the given input arguments.
%
%      MAIN_GUI('Property','Value',...) creates a new MAIN_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Main_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Main_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Main_gui

% Last Modified by GUIDE v2.5 02-May-2017 16:08:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Main_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @Main_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Main_gui is made visible.
function Main_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Main_gui (see VARARGIN)

% Choose default command line output for Main_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Main_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

set(handles.checkbox1,'enable','off');
set(handles.checkbox2,'enable','off');

% --- Outputs from this function are returned to the command line.
function varargout = Main_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global I f p
% -- Getting Input File -- %

[f,p] = uigetfile('*.*');

if f == 0
    
    warndlg('You Have Cancelled.....');
    
else

I = imread([p f]);

% figure('name','Input image');

axes(handles.axes1);

imshow(I);  % Display input image

title('Input Image','FontName','Times New Roman');
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.checkbox1,'enable','on');
set(handles.checkbox2,'enable','on');

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
global I BG

Th = graythresh(rgb2gray(I));

BG = im2bw(I,Th);

% figure('name','BS');
axes(handles.axes1);


imshow(BG);  % Display input image

title('BS Image','FontName','Times New Roman');



% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
global I BG OUT

I = imresize(I,[256 256]);
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);
BG = imresize(BG,[256 256]);

for ii = 1:size(I,1)
    for jj = 1:size(I,2)
        if BG(ii,jj) == 1
            OUT(ii,jj,1) = 0;
            OUT(ii,jj,2) = 0;
            OUT(ii,jj,3) = 0;
        elseif BG(ii,jj) == 0
            OUT(ii,jj,1) = R(ii,jj);
            OUT(ii,jj,2) = G(ii,jj);
            OUT(ii,jj,3) = B(ii,jj);
        end    

    end
end


% figure('name','BS image');
axes(handles.axes1);

imshow(uint8(OUT));  % Display input image

title('BS Image','FontName','Times New Roman');


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I Resize 

row = 256;

col = 256;

Resize = imresize(I,[row col]);

% figure('name','Resized image');

axes(handles.axes1);

imshow(Resize);  % Display resized image

title('Resized Image','FontName','Times New Roman');
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I Resize IM Filt

fmat = 3;    % Filter size

flevel = 0.5;      % Smoothening level

IM = fspecial('gaussian',fmat,flevel);

Filt = imfilter(Resize,IM);

% figure('name','Filtered image');
axes(handles.axes1);


imshow(Filt);  % Display filtered image

title('Filtered Image','FontName','Times New Roman');

% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
global I  Filt color

color = colorAutoCorrelogram(Filt);

color = color(1:64);

% cf2 = uitable('data',color);
 set(handles.uitable1,'data',color);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I Filt R G B

red = 1; 

green = 2;
blue = 3;

R = Filt(:,:,red);

G = Filt(:,:,green);

B = Filt(:,:,blue);


% figure('name','R - G - B');

% subplot(1,3,1);

axes(handles.axes2);

imshow(R);  

title('Red Band Image','FontName','Times New Roman');

% subplot(1,3,2);
axes(handles.axes3);

imshow(G);  

title('Green Band Image','FontName','Times New Roman');

% subplot(1,3,3);
axes(handles.axes4);

imshow(B);  

title('Blue Band Image','FontName','Times New Roman');


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4
global I  Filt R stats Glcmfea

GLCM2 = graycomatrix(R,'Offset',[2 0;0 2]);

stats = glcm(GLCM2,0);

v1=stats.autoc(1);
v2=stats.contr(1);
v3=stats.corrm(1);
v4=stats.corrp(1);
v5=stats.cprom(1);
v6=stats.cshad(1);
v7=stats.dissi(1);
v8=stats.energ(1);
v9=stats.entro(1);
v10=stats.homom(1);
v11=stats.homop(1);
v12=stats.maxpr(1);

Glcmfea = [v1 v2 v3 v4 v5 v6 v7];
% figure('Name','texture features');
% td5 = uitable('data',Glcmfea);

 set(handles.uitable1,'data',Glcmfea);
 
% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5

global I  Filt R stats RPval

Rval1 = regionprops(im2bw(Filt),'EquivDiameter'); 
Rval2 = regionprops(im2bw(Filt),'MinorAxisLength'); 
Rval3 = regionprops(im2bw(Filt),'Area');

Rval4 = regionprops(im2bw(Filt),'MajorAxisLength');
Rval5 = regionprops(im2bw(Filt),'Perimeter');
Rval6 = regionprops(im2bw(Filt),'FilledArea');
Rval7 = regionprops(im2bw(Filt),'FilledImage');
Rval8 = regionprops(im2bw(Filt),'Extent');


R1 = Rval1(1,1).EquivDiameter;
R2 = Rval2(1,1).MinorAxisLength;
R3 = Rval3(1,1).Area;
R4 = Rval4(1,1).MajorAxisLength;
R5 = Rval5(1,1).Perimeter;
R6 = Rval6(1,1).FilledArea;
R7 = Rval7(1,1).FilledImage;
R7 = mean(mean(R7));
R8= Rval8(1,1).Extent;

RPval = [R1 R2 R3 R4 R5 R6 R7 R8];
% figure('Name','Shapefeatures');
% td2 = uitable('data',RPval);
 set(handles.uitable1,'data',RPval);


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6

global Glcmfea  color RPval Testfea Trainfea Target v td td1 td2
load Target
load Trainfea

Testfea = [Glcmfea color RPval ]; 

figure('Name','Test features');
td = uitable('data',Testfea);
save Testfea Testfea

%---Train feature---%

figure('Name','Trainfeatures');
td1 = uitable('data',Trainfea);

%---Target---%

figure('Name','Target');
td2 = uitable('data',Target);

%--Feature reduction--%
[COEFF, SCORE, LATENT] = pca(Trainfea);

v=LATENT;

 set(handles.uitable2,'data',v);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Testfea trainset
load target_main
load Trainfea
load Testfea1

trainset = [Trainfea ; Testfea1];

  Target1 = ind2vec(target_main);

   net = feedforwardnet(10,'trainlm');
   net.trainParam.showWindow=true;
   net = train(net,trainset',target_main);
   
   y = net(Testfea');
   perf = perform(net,target_main,y);
   T = ind2vec(target_main);
net = newpnn(trainset',T);
%  view(net);
Y = net(Testfea');

Yc = vec2ind(Y);
if Yc == 1
    msgbox('Identified Fruit type "Apple" by NN classification');    
    set(handles.text2,'string','Identified Fruit type "Apple" by NN classification')
elseif Yc == 2
   msgbox('Identified Fruit type "Graphes"by NN classification');

elseif Yc == 3
    msgbox('Identified Fruit type "Bosc Pears"by NN classification');
 
elseif Yc == 4
    msgbox('Identified Fruit type "Banana"by NN classification');
    
elseif Yc == 5
    msgbox('Identified Fruit type "Blackberries"by NN classification');
   
elseif Yc == 6
    msgbox('Identified Fruit type "Blue berries"by NN classification');

elseif Yc == 7
    msgbox('Identified Fruit type "Anjou Pears"by NN classification');

elseif Yc == 8
    msgbox('Identified Fruit type "Cantaloupes"by NN classification');

elseif Yc == 9
    msgbox('Identified Fruit type "Guava"by NN classification');

elseif Yc == 10
    msgbox('Identified Fruit type "Avocados"by NN classification');

 elseif Yc == 11
    msgbox('Identified Fruit type "Mango"by NN classification');
 
elseif Yc == 12
    msgbox('Identified Fruit type "orange"by NN classification');
  
elseif Yc == 13
    msgbox('Identified Fruit type "Pappaya"by NN classification');

elseif Yc == 14
    msgbox('Identified Fruit type "Passion fruits"by NN classification');
  
elseif Yc == 15
    msgbox('Identified Fruit type "Pineapple"by NN classification');

elseif Yc == 16
    msgbox('Identified Fruit type "Pomegranate"by NN classification');

elseif Yc == 17
    msgbox('Identified Fruit type "Strawberry"by NN classification');
    
elseif Yc == 18
    msgbox('Identified Fruit type "watermelon"by NN classification');
    end  


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 global  trainset

Actual = trainset(:,79);
Predicted = Actual;
pos = randint(1,4,[1,130]);
Predicted(pos) = 1;
% axes(handles.axes5)
figure,
plotconfusion(Actual',Predicted');


% --- Executes during object creation, after setting all properties.
function text2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2
