%Copyright (c) 2019 Andrea Behanova, Ali Abdollazadeh
% A.I. Virtanen Inbstitute for Molecular Sciences, University of Eastern
% Finland, Finland

%version 1.0  13.12.2019

%Permission is hereby granted, free of charge, to any person obtaining a copy 
%of this software and associated documentation files (the "Software"), to deal
%in the Software without restriction, including without limitation the rights
%to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%copies of the Software, and to permit persons to whom the Software is
%furnished to do so, subject to the following conditions:

%The above copyright notice and this permission notice shall be included in all
%copies or substantial portions of the Software.

%THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
%SOFTWARE.

% This software uses Bio-Formats 5.9.2 package, which can be found in https://www.openmicroscopy.org/bio-formats/downloads/

function varargout = miniTEM_image_segmentation(varargin)
% MINITEM_IMAGE_SEGMENTATION MATLAB code for miniTEM_image_segmentation.fig
%      MINITEM_IMAGE_SEGMENTATION, by itself, creates a new MINITEM_IMAGE_SEGMENTATION or raises the existing
%      singleton*.
%
%      H = MINITEM_IMAGE_SEGMENTATION returns the handle to a new MINITEM_IMAGE_SEGMENTATION or the handle to
%      the existing singleton*.
%
%      MINITEM_IMAGE_SEGMENTATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MINITEM_IMAGE_SEGMENTATION.M with the given input arguments.
%
%      MINITEM_IMAGE_SEGMENTATION('Property','Value',...) creates a new MINITEM_IMAGE_SEGMENTATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before miniTEM_image_segmentation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to miniTEM_image_segmentation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help miniTEM_image_segmentation

% Last Modified by GUIDE v2.5 11-Jun-2020 10:13:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @miniTEM_image_segmentation_OpeningFcn, ...
                   'gui_OutputFcn',  @miniTEM_image_segmentation_OutputFcn, ...
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


% --- Executes just before miniTEM_image_segmentation is made visible.
function miniTEM_image_segmentation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to miniTEM_image_segmentation (see VARARGIN)


% add path to the bioformat loader
addpath('C:\Users\andrb\Desktop\FinVector\bfmatlab')

% add path to the figure export functions
addpath('C:\Users\andrb\Desktop\FinVector\export_fig-master')

% handles initiation
handles.data = [];
handles.indx = [];
handles.file = [];
handles.virus = [];
handles.label = [];
handles.zoom.number = 1;
handles.zoom.active = 0;

% setting the position of the software window
set(handles.Display,'Units', 'normalized');
set(handles.Display,'Position', [0.23 0.2 0.75 0.75]);

% Choose default command line output for miniTEM_image_segmentation
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes miniTEM_image_segmentation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = miniTEM_image_segmentation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function open_file_Callback(hObject, eventdata, handles)
% hObject    handle to open_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Opening load window
[Files, pathname]=uigetfile('*.ome.tif', 'Select files to load:','MultiSelect','on');

% check if any file is selected
if size(Files,2) == 1
    return
end
    
% initiation of wait bar if more than one file selected
if iscell(Files)
    L = size(Files,2);
    f = waitbar(1/L,'Loading files');
else
    L = 1;
    filename = Files;
end

% loading of the files + adding to the pup-up menu and file list
for i = 1:L
    if iscell(Files)
        filename = Files{1,i};
    end
    data = bfopen([pathname filename]);
    s1 = data{1,1}{1,1};
    %save to the memory
    handles.data = [handles.data;{s1}];

    % Adding file to pop-up menu
    txt = get(handles.file_popup,'String');
    txt = [txt; {filename}];
    set(handles.file_popup,'String',txt);

    % Adding file to file list
    txt = get(handles.Files_listbox,'String');
    txt = [txt; {filename}];
    set(handles.Files_listbox,'String',txt);

    files = get(handles.Files_listbox,'String');
    handles.file = files(2:end,1);
    
    if iscell(Files)
        waitbar(i/L,f)
    end
end

%close the waitbar
if iscell(Files)
    close(f)
end

%store the handles
guidata(hObject, handles);


% --- Executes on selection change in Files_listbox.
function Files_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to Files_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Files_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Files_listbox


% --- Executes during object creation, after setting all properties.
function Files_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Files_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in file_popup.
function file_popup_Callback(hObject, eventdata, handles)
% hObject    handle to file_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns file_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from file_popup

% get the selected string and save to the handles
contents = cellstr(get(hObject,'String'));
display_choice = contents(get(hObject, 'Value'));
handles.dispChoice = display_choice;

% restart the saved segmentations of the adenoviruses and the whole label
handles.virus = [];
handles.label = [];

%Display selected file
if strcmp(handles.dispChoice, 'Select file...')
    set(get(gca,'children'),'Visible','off')
    handles.dispChoice = [];
elseif isempty(handles.dispChoice)
    return
else
    indx = strcmp(handles.Files_listbox.String, handles.dispChoice);
    indx = indx(2:end);
    handles.indx = indx;
    data = handles.data{indx};
    
    axes(handles.Display)
    imshow(data,[])
    set(handles.Display,'xlim',[0 size(data,2)],'ylim',[0 size(data,1)])
    % proofreading buttons visibility set to off
    set(handles.add_label_button,'Visible','off')
    set(handles.remove_label,'Visible','off')
    set(handles.save_label_button,'Visible','off')

    set(handles.Add_debris_button,'Visible','off')
    set(handles.Remove_debris_button,'Visible','off')
    set(handles.Save_whole_label,'Visible','off')
end

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function file_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in segmentation_button.
function segmentation_button_Callback(hObject, eventdata, handles)
% hObject    handle to segmentation_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ADENOVIRUSES SEGMENTATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% checks if a file is selected
if isempty(handles.dispChoice)
    return
end

% proofreading buttons visibility setting
% adenoviruses
set(handles.add_label_button,'Visible','on')
set(handles.remove_label,'Visible','on')
set(handles.save_label_button,'Visible','on')
% debris
set(handles.Add_debris_button,'Visible','off')
set(handles.Remove_debris_button,'Visible','off')
set(handles.Save_whole_label,'Visible','off')

% get image from the memory
indx = handles.indx;
data = handles.data{indx};

%% Histogram adjustment
Imad = imadjust(data);

%% Median filtering
J = medfilt2(Imad,[15 15]);

%% Selection of low intensity areas
th = round(max(J(:))/1.5);
J(J>th)=max(J(:));
J(J<=th)=0;

J=~logical(J);
J = imdilate(J,true(15));
J = imfill(J,'holes');
J = bwareaopen(J,2000);

Image = data;
Image(J==0) = 0;
Imad(J==0) = 0;

%% Hough Transform
[centers, radii, metric] = imfindcircles(Imad,[16 50],'EdgeThreshold',...
    0.0001,'ObjectPolarity','bright','Sensitivity',0.87);
centers = round(centers);

Imad = imadjust(data);

%% Removing candidates od adenoviruses which do not have dar area around

if length(centers)>70  %if lot of FP change it to lower
    for i = 1:length(centers)
        
        x1 = centers(i,2)-100;
        x2 = centers(i,2)+100;
        y1 = centers(i,1)-100;
        y2 = centers(i,1)+100;

        if x1<1
            x1=1;
        end
        if y1<1
            y1=1;
        end
        if x2>size(Imad,2)
            x2=size(Imad,2);
        end
        if y2>size(Imad,1)
            y2=size(Imad,1);
        end

        candidate = Imad(x1:x2,y1:y2);
        h = imhist(candidate);
        [int,peak] = max(h);
        if peak >50
            centers(i,1)=0;
            centers(i,2)=0;
            radii(i)=0;
        end
    end
end

%% Visualization

numbers = find(centers(:,1));
centers = centers(numbers,:);
radii = nonzeros(radii);

% creating label
mask = zeros(size(Imad));
for i = 1:size(centers,1)
    circ = drawcircle('Center',centers(i,:),'Radius',radii(i));
    BW = createMask(circ);
    delete(circ)
    mask(BW)=i;
end

% saving to the memory
handles.virus.centers = centers;
handles.virus.radii = radii;
handles.virus.mask = mask;

guidata(hObject, handles);
Disp(hObject, eventdata, handles)

function Disp(hObject, eventdata, handles)
% displays the detected adenoviruses
indx = handles.indx;
data = handles.data{indx};
Imad = imadjust(data);
imshow(Imad)

centers = handles.virus.centers;
radii = handles.virus.radii;
viscircles(centers, radii,'EdgeColor','r');

% --- Executes on button press in add_label_button.
function add_label_button_Callback(hObject, eventdata, handles)
% hObject    handle to add_label_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% checks if adenovirus detection exists
if isempty(handles.virus)
    return
end

% restores data from the memory
centers = handles.virus.centers;
radii = handles.virus.radii;
mask = handles.virus.mask;

% draws an ellipse
h = imellipse;
pos = round(getPosition(h));
BW = createMask(h);
delete(h)
mask(BW)=max(mask(:))+1;
center = round([pos(1)+pos(3)/2, pos(2)+pos(4)/2]);
radius = pos(3)/2;
% add drawn ellipse to the list of adenoviruses
centers = [centers;center];
radii = [radii; radius];

% saves updated adenovirus setection to the memory
handles.virus.centers = centers;
handles.virus.radii = radii;
handles.virus.mask = mask;
guidata(hObject, handles);
Disp(hObject, eventdata, handles)


% --- Executes on button press in remove_label.
function remove_label_Callback(hObject, eventdata, handles)
% hObject    handle to remove_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% checks if adenovirus detection exists
if isempty(handles.virus)
    return
end

% restores data from the memory
indx = handles.indx;
data = handles.data{indx};
centers = handles.virus.centers;
radii = handles.virus.radii;
mask = handles.virus.mask;

% removes selected adenoviruses
[y,x] = getpts; y = round(y(:,1)); x = round(x(:,1));
index = [];
for i = 1:length(x)
    if (x(i)>0) && (x(i)<size(data,2)) && (y(i)>0) && (y(i)<size(data,1))
        linearInd = sub2ind([size(data,2),size(data,1)], x(i), y(i));
        index(i) = nonzeros(mask(linearInd));
        if index(i)==max(mask(:))
            centers(index(i),:) = [];
            radii(index(i)) = [];
        else
            centers(index(i),:) = 0;
            radii(index(i)) = 0;
        end
        mask(mask==index(i))=0;
    else
        return
    end
end

% saves updated adenovirus setection to the memory
handles.virus.centers = centers;
handles.virus.radii = radii;
handles.virus.mask = mask;
guidata(hObject, handles);
Disp(hObject, eventdata, handles)

% --- Executes on button press in save_label_button.
function save_label_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_label_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% checks if adenovirus detection exists
if isempty(handles.virus)
    return
end

% restores data from the memory
mask = handles.virus.mask;
indx = handles.indx;
name = handles.file{indx};

% saving
name = [name(1:end-8), '_target.mat'];
save(name,'mask', '-v7.3')


% --- Executes on button press in segmentation_debris.
function segmentation_debris_Callback(hObject, eventdata, handles)
% hObject    handle to segmentation_debris (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DEBRIS SEGMENTATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% checks if a file is selected
if isempty(handles.dispChoice)
    return
end

% proofreading buttons visibility setting
% adenovires
set(handles.add_label_button,'Visible','off')
set(handles.remove_label,'Visible','off')
set(handles.save_label_button,'Visible','off')
% debris
set(handles.Add_debris_button,'Visible','on')
set(handles.Remove_debris_button,'Visible','on')
set(handles.Save_whole_label,'Visible','on')

f = waitbar(0.1,'Debris Segmentation in process...');

% restore data from the memory
indx = handles.indx;
data = handles.data{indx};

%% Histogram adjustment
Imad = imadjust(data);

%% Maximally stable extremal regions features detection

regions = detectMSERFeatures(Imad,'RegionAreaRange',[10 1500], 'ThresholdDelta',1);
mask = zeros(size(Imad));
for i = 1:length(regions.PixelList)
    ind = sub2ind(size(Imad),regions.PixelList{i,1}(:,2),regions.PixelList{i,1}(:,1));
    mask(ind)=1;
end

waitbar(0.2,f)
%% Filling holes in the segmentation
mask = imfill(mask,'holes');

%% Division of too close segments
m1 = imerode(mask,true(3));
m2 = bwlabel(m1,4);
mask = imdilate(m2,true(3));

waitbar(0.3,f)
%% Loading the mask of adenoviruses segmentation
[file,path] = uigetfile('*.mat','Load adenovirus mask');
adenovir = importdata(fullfile(path,file));

%% Removing false detection of debris in position of adenoviruses
mask(logical(imdilate(adenovir,true(6))))=0;

%% Segmentation od rods
stats = regionprops(mask,'Area','MajorAxisLength','MinorAxisLength');
maj = [stats.MajorAxisLength];
min = [stats.MinorAxisLength];

non_Cidx = (maj>60);
non_Cidx2 = (min<30);
non_C = mask;

for i = 1:length(non_Cidx)
    if non_Cidx(i)==0 || non_Cidx2(i)==0 
        non_C(non_C==i)=0;
    end
end
rods = non_C;
mask(logical(rods)) = 0;
waitbar(0.5,f)

%% Removing really small regions
stats = regionprops(mask,'Area');
areas = cat(1,stats.Area);
standev = std(areas);
big_Aidx = (areas>standev);
big_A = mask;

for i = 1:length(big_Aidx)
    if big_Aidx(i)==0
        big_A(big_A==i)=0;
    end
end

waitbar(0.6,f)
%% Division of the debris into smaller segments 
I = imgaussfilt(Imad,2);
reg_max_big_A = imregionalmax(I);
reg_max_big_A(big_A == 0)=0;
D = bwdist(reg_max_big_A);
DL = watershed(D);
mask2 = logical(mask);
mask2(DL==0)=0;

%% Division of too close segments
mask2 = bwareaopen(mask2, 50);
m1 = imerode(mask2,true(3));
m2 = bwlabel(m1,4);
big_Debris = imdilate(m2,true(3));

%% Division of debris into 2 groups: small and big debris based on a area threshold
waitbar(0.7,f)
stats = regionprops(big_Debris,'Area');
areas = cat(1,stats.Area);
big_Debris_idx = (areas>=200);

for i = 1:length(big_Debris_idx)
    if big_Debris_idx(i)==1
        big_Debris(big_Debris==i)=2;
    else
       big_Debris(big_Debris==i)=1; 
    end
end
mask2 = big_Debris;

waitbar(0.9,f)
%% Finalizing the mask
%add rods and adenoviruses
mask2(logical(rods))=3;
mask2(logical(adenovir))=7;
handles.label = mask2;

%edges
J = imerode(mask2,true(6));
mask2 = mask2-J;

waitbar(1,f)

%% Visualization
axes(handles.Display)
imshow(Imad); hold on;
Lrgb = label2rgb(mask2,'lines', 'k');
himage = imshow(Lrgb); himage.AlphaData = 0.5;

close(f)
guidata(hObject, handles);


% --------------------------------------------------------------------
function Open_exst_label_Callback(hObject, eventdata, handles)
% hObject    handle to Open_exst_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% checks if a file is selected
if isempty(handles.indx)
    f = warndlg('Select file in pop-up menu','Warning');
    return
end

% dialog box
[File, pathname]=uigetfile('*.mat', 'Select label to load:');

if size(File,2) == 1
    return
end

% proofreading buttons visibility setting
% adenoviruses
set(handles.add_label_button,'Visible','off')
set(handles.remove_label,'Visible','off')
set(handles.save_label_button,'Visible','off')
% debris
set(handles.Add_debris_button,'Visible','on')
set(handles.Remove_debris_button,'Visible','on')
set(handles.Save_whole_label,'Visible','on')

% importing data
mask = importdata(fullfile(pathname,File));
label = mask;
handles.label = label;

% getting original image
indx = handles.indx;
data = handles.data{indx};
Imad = imadjust(data);

% Visualization
J = imerode(label,true(8));
label_d = label-J;

axes(handles.Display)
imshow(Imad,[]); hold on;
Lrgb = label2rgb(label_d,'lines', 'k');
himage = imshow(Lrgb); himage.AlphaData = 0.5;
guidata(hObject, handles);


% --- Executes on button press in Add_debris_button.
function Add_debris_button_Callback(hObject, eventdata, handles)
% hObject    handle to Add_debris_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% checks if a segmentation label exists
if isempty(handles.label)
    return
end

% restoring data
indx = handles.indx;
data = handles.data{indx};
[r,c] = size(data);
zoom = handles.zoom.number;

% get the location of the zoomed window
[r1,r2,c1,c2] = get_window(r,c,zoom);

% changing window view
if zoom == 1
    set(handles.zoom_next,'Visible', 'on')
    Disp_window(hObject, eventdata, handles, r1, r2, c1, c2)
    set(handles.Display_2,'Visible', 'on');
    set(handles.Display_2,'Units', 'normalized');
    set(handles.Display_2,'Position', [0.23 0.2 0.32 0.75]);
    set(handles.Display,'Position', [0.55 0.2 0.32 0.75]);
end

%drawing
g = get(gca,'children');
h = drawfreehand('Closed',0);
BW = createMask(h, g(1));
delete(h)
[x,y] = find(BW);
point = zeros(size(data));
for i= 1:length(x)
    x(i) = x(i)+r1-1;
    y(i) = y(i)+c1-1;
    point(x(i),y(i))=1;
end

% dilating drawn region
BW = imdilate(point,strel('disk',5));
new_idx = find(BW);

% visualization
label = handles.label;
label(new_idx)=1;
handles.label = label;
guidata(hObject, handles);
Disp_window(hObject, eventdata, handles, r1, r2, c1, c2)

function Disp_window(hObject, eventdata, handles, r1, r2, c1, c2)
indx = handles.indx;
data = handles.data{indx};
Imad = imadjust(data);
mask = handles.label;
mask_crop = mask(r1:r2,c1:c2);
J = imerode(mask_crop,true(6));
mask_crop = mask_crop-J;

if r1==1 && r2==size(data,1)
    axes(handles.Display_2)
    set(get(gca,'children'),'Visible','off')
else
    axes(handles.Display_2)
    imshow(Imad(r1:r2,c1:c2));
end

axes(handles.Display)
imshow(Imad(r1:r2,c1:c2)); hold on;
Lrgb = label2rgb(mask_crop,'lines', 'k');
himage = imshow(Lrgb); himage.AlphaData = 0.5;
set(handles.Display,'xlim',[0 size(mask_crop,2)],'ylim',[0 size(mask_crop,1)])

function [r1,r2,c1,c2] = get_window(r,c,zoom)
% This function returns corners' indexes of the zoomed image.
step_r = round(r/3);
step_c = round(c/3);
switch zoom
    case 1
        r1 = 1;
        r2 = step_r;
        c1 = 1;
        c2 = step_c;
    case 2
        r1 = 1;
        r2 = step_r;
        c1 = step_c+1;
        c2 = step_c*2;
    case 3
        r1 = 1;
        r2 = step_r;
        c1 = step_c*2+1;
        c2 = c;
    case 4
        r1 = step_r+1;
        r2 = step_r*2;
        c1 = 1;
        c2 = step_c;
    case 5
        r1 = step_r+1;
        r2 = step_r*2;
        c1 = step_c+1;
        c2 = step_c*2;
    case 6
        r1 = step_r+1;
        r2 = step_r*2;
        c1 = step_c*2+1;
        c2 = c;
    case 7
        r1 = step_r*2+1;
        r2 = r;
        c1 = 1;
        c2 = step_c;
    case 8
        r1 = step_r*2+1;
        r2 = r;
        c1 = step_c+1;
        c2 = step_c*2;
    case 9
        r1 = step_r*2+1;
        r2 = r;
        c1 = step_c*2+1;
        c2 = c;
end

% --- Executes on button press in zoom_next.
function zoom_next_Callback(hObject, eventdata, handles)
% hObject    handle to zoom_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% restoring data
indx = handles.indx;
data = handles.data{indx};
[r,c] = size(data);
% changing the order of the window to the following one
zoom = handles.zoom.number+1;
handles.zoom.number = zoom;

% getting the corners' indexes for the cropped window
if zoom == 10
    set(handles.zoom_next,'Visible', 'off')
    r1 = 1;
    r2 = r;
    c1 = 1;
    c2 = c;
    handles.zoom.number = 1;
    set(handles.Display_2,'Visible', 'off')
    set(handles.Display,'Position', [0.23 0.2 0.75 0.75]);
else
    [r1,r2,c1,c2] = get_window(r,c,zoom);
end
 
% saving changed data and updating view with the new window
guidata(hObject, handles);
Disp_window(hObject, eventdata, handles, r1, r2, c1, c2)

% --- Executes on button press in Remove_debris_button.
function Remove_debris_button_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_debris_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% checks if a segmentation label exists
if isempty(handles.label)
    return
end

% restoring data
indx = handles.indx;
data = handles.data{indx};
[r,c] = size(data);
zoom = handles.zoom.number;

% get the location of the zoomed window
[r1,r2,c1,c2] = get_window(r,c,zoom);

if zoom == 1
    set(handles.zoom_next,'Visible', 'on')
    Disp_window(hObject, eventdata, handles, r1, r2, c1, c2)
    set(handles.Display_2,'Units', 'normalized');
    set(handles.Display_2,'Position', [0.23 0.2 0.32 0.75]);
    set(handles.Display,'Position', [0.55 0.2 0.32 0.75]);
    
end

% Selecting the regions to remove
[y,x] = getpts; y = round(y(:,1)); x = round(x(:,1));
x = x+r1-1;
y = y+c1-1;

% removing the regions of the selected points
mask = bwlabel(logical(handles.label));
for i =1:length(x)
    idx = mask(x(i,1),y(i,1));
    mask(mask==idx)=0;
end
label = handles.label;
label(mask==0)=0;

% saving updated label to the memory + diplay updated window
handles.label = label;
guidata(hObject, handles);
Disp_window(hObject, eventdata, handles, r1, r2, c1, c2)

% --- Executes on button press in Save_whole_label.
function Save_whole_label_Callback(hObject, eventdata, handles)
% hObject    handle to Save_whole_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% checks if a segmentation label exists
if isempty(handles.label)
    return
end

% restoring label and data name
label = handles.label;
indx = handles.indx;
name = handles.file{indx};
name = [name(1:13), '_label.mat'];

% saving
[filename, filepath] = uiputfile('*.mat', 'Save the final segmentation:',name);
FileName = fullfile(filepath, filename);
save(FileName,'label', '-v7.3')

% --- Executes on button press in Save_screen.
function Save_screen_Callback(hObject, eventdata, handles)
% hObject    handle to Save_screen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% checks if a file is selected in the pop-up menu
if isempty(handles.indx)
    return
end

% restoring the data name + adding suffix
indx = handles.indx;
filename = handles.file{indx};
if isempty(handles.label)
    filename = [filename(1:13) '_original'];
else
    filename = [filename(1:13) '_segmentation'];
end

% exposrtin screenshot
export_fig(handles.Display, filename);
