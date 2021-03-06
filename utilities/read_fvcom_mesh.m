function [Mobj] = read_fvcom_mesh(gridfile)

% Read fvcom mesh file into Matlab mesh object
%
% [Mobj] = function read_fvcom_mesh(gridfile)
%
% DESCRIPTION:
%    Read FVCOM Grid file (connectivity + nodes)
%    Store in a matlab mesh object
%
% INPUT [keyword pairs]:
%   'gridfile'  = fvcom mesh file
%
% OUTPUT:
%    Mobj = matlab structure containing mesh data
%
% EXAMPLE USAGE
%    Mobj = read_fvcom_mesh('tst_grd.dat')
%
% Author(s):
%    Geoff Cowles (University of Massachusetts Dartmouth)
%    Pierre Cazenave (Plymouth Marine Laboratory)
%    Rory O'Hara Murray (Marien Scotland Science)
%
% Revision history
%    2014-04-23 Minor formatting fixes and add the global ftbverbose flag.
%    2014-08-19 Remove loops to speed up reading in the file.
%==============================================================================

subname = 'read_fvcom_mesh';
global ftbverbose;
if ftbverbose
    fprintf('\nbegin : %s \n', subname)
end


%------------------------------------------------------------------------------
% Create a blank mesh object
%------------------------------------------------------------------------------
Mobj = make_blank_mesh();
coordinate = 'cartesian';
have_bath = false;
have_xy = true;
have_lonlat = false;


%------------------------------------------------------------------------------
% Read the mesh from the fvcom grid file
%------------------------------------------------------------------------------


fid = fopen(gridfile,'r');
if(fid  < 0)
    error(['file: ' gridfile ' does not exist']);
end;

%----------------------------------------------------
% read in the fvcom connectivity and vertices
%----------------------------------------------------
C = textscan(fid, '%s %s %s %d', 1); nVerts = C{4};
C = textscan(fid, '%s %s %s %d', 1); nElems = C{4};
tri = zeros(nElems,3);
x   = zeros(nVerts,1);
y   = zeros(nVerts,1);
h   = zeros(nVerts,1);
lon = zeros(nVerts,1);
lat = zeros(nVerts,1);
ts  = zeros(nVerts,1);

if ftbverbose
    fprintf('reading mesh file\n');
    fprintf('# nodes %d\n',nVerts);
    fprintf('# elems %d\n',nElems);
end
C = textscan(fid,' %d %d %d %d %d',nElems);
tri(:,1) = C{2};  tri(:,2) = C{3}; tri(:,3) = C{4};

C = textscan(fid, '%d %f %f %f', nVerts);
x(:) = C{2};
y(:) = C{3};

if ftbverbose; fprintf('mesh read in\n'); end
fclose(fid);

%------------------------------------------------------------------------------
% Transfer to Mesh structure
%------------------------------------------------------------------------------

Mobj.nVerts  = nVerts;
Mobj.nElems  = nElems;
Mobj.nativeCoords = coordinate;

if(have_lonlat)
    Mobj.have_lonlat  = have_lonlat;
end;
if(have_xy)
    Mobj.have_xy      = have_xy;
end;
if(have_bath)
    Mobj.have_bath    = have_bath;
end;
Mobj.x            = x;
Mobj.y            = y;
Mobj.ts           = ts;
Mobj.lon          = lon;
Mobj.lat          = lat;
Mobj.h            = h;
Mobj.tri          = tri;


if ftbverbose
    fprintf('end   : %s \n', subname)
end


