function save_fig(h, name, format)
% Matlab has a wierd way of saving figures and keeping the plot looking
% exactly the way it does on your screen.  Thi function simplifies the 
% entire process in a way that is barely documented. 
%
% Usage:      SAVE_FIG(h, name, format);
%
%             H is the handle to the figure.  This can be obtain in the 
%               following manner:  H = figure(1);
%             NAME is the filename without extension
%             FORMAT is the graphic format.  Options are:
%             
%                   'bmpmono'    BMP monochrome BMP
%                   'bmp16m'     BMP 24-bit BMP
%                   'bmp256'     BMP 8-bit (256-color) 
%                   'bmp'        BMP 24-bit	
%                   'meta'       EMF
%                   'eps'        EPS black and white
%                   'epsc'       EPS color
%                   'eps2'       EPS Level 2 black and white
%                   'epsc2'      EPS Level 2 color
%                   'fig'        FIG Matlab figure file
%                   'hdf'        HDF 24-bit
%                   'ill'        ILL (Adobe Illustrator)
%                   'jpeg'       JPEG 24-bit
%                   'pbm'        PBM (plain format) 1-bit
%                   'pbmraw'     PBM (raw format) 1-bit
%                   'pcxmono'    PCX 1-bit
%                   'pcx24b'     PCX 24-bit color PCX file format
%                   'pcx256'     PCX 8-bit newer color (256-color)
%                   'pcx16'      PCX 4-bit older color (16-color)
%                   'pdf'        PDF Color PDF file format
%                   'pgm'        PGM Portable Graymap (plain format)
%                   'pgmraw'     PGM Portable Graymap (raw format)
%                   'png'        PNG 24-bit
%                   'ppm'        PPM Portable Pixmap (plain format)
%                   'ppmraw'     PPM Portable Pixmap (raw format)
%                   'svg'        SVG Scalable Vector Graphics
%                   'tiff'       TIFF 24-bit
%
% Author: sparafucile17

if(strcmp(format,'fig'))
    saveas(h, name, 'fig');
else
    options.Format = format;
    hgexport(h, name, options);
end