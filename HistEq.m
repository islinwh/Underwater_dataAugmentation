function EquaImage = HistEq(I)
%%%%%%%%%%%%%%%%%%%
% % �Ա�ֱ��ͼ�������
%%%%%%%%%%%%%%%%%%%

Image = double( I ) ;
[h,w,c] =size(I) ;
%%%%-----------��ɫͼ���ͨ������-------------%%
if c ==3
    R = Image( :, :, 1 ) ;
    G = Image( :, :, 2 ) ;
    B = Image( :, :, 3 ) ;

    %���ػҶ�ͳ
    RNumPixel = zeros( 1, 256 ) ;
    GNumPixel = zeros( 1, 256 ) ;
    BNumPixel = zeros( 1, 256 ) ;
    for i = 1: h   
        for j = 1: w
         RNumPixel( 1, R( i, j) + 1) = RNumPixel( 1, R( i, j) + 1) + 1;
         GNumPixel( 1, G( i, j) + 1) = GNumPixel( 1, G( i, j) + 1) + 1;
         BNumPixel( 1, B( i, j) + 1) = BNumPixel( 1, B( i, j) + 1) + 1;  
        end    
    end
 
    %����Ҷȷֲ��ܶ�
    RProbPixel = zeros( 1, 256 ) ;
    GProbPixel = zeros( 1, 256 ) ;
    BProbPixel = zeros( 1, 256 ) ;
    for i = 1 : 256
        RProbPixel ( 1, i ) = RNumPixel( i ) / ( w*h*1.0 ) ;
        GProbPixel ( 1, i ) = GNumPixel( i ) / ( w*h*1.0 ) ;
        BProbPixel ( 1, i ) = BNumPixel( i ) / ( w*h*1.0 ) ;
    end

    %�����ۼ�ֱ��ͼ�ֲ�
    RSumPixel =  double( zeros(1, 256) ) ;
    GSumPixel =  double( zeros(1, 256) ) ;
    BSumPixel =  double( zeros(1, 256) ) ;

    for i = 1 : 256
        if i ==1 
            RSumPixel ( i ) = RProbPixel (i) ;
            GSumPixel ( i ) = GProbPixel (i) ;
            BSumPixel ( i ) = BProbPixel (i) ;
        else       
            RSumPixel (i) = RSumPixel (i-1) + RProbPixel ( i ) ;
            GSumPixel (i) = GSumPixel (i-1) + GProbPixel ( i ) ;
            BSumPixel (i) = BSumPixel (i-1) + BProbPixel ( i ) ;
        end  
    end

    %�ۼƷֲ�ȡ��
    RSumPixel  = uint8( 255 .* RSumPixel +0.5 ) ;
    GSumPixel  = uint8( 255 .* GSumPixel +0.5 ) ;
    BSumPixel  = uint8( 255 .* BSumPixel +0.5 ) ;

    %�ԻҶ�ֵ����ӳ��
    EquaImage = zeros( h, w, 3 ) ;
    for i = 1 : h 
        for j = 1 : w 
            EquaImage( i, j, 1) = RSumPixel ( R( i, j ) +1 );
            EquaImage( i, j, 2) = GSumPixel ( G( i, j ) +1 );
            EquaImage( i, j, 3) = BSumPixel ( B( i, j ) +1 );
        end
    end%%%%%%%%%%%%------------------------------ ------- 
 
else% % %%%--------------�Ҷ�ͼ��-----------------%%%
    R = Image( :, :) ;
    
    %���ػҶ�ͳ
    RNumPixel = zeros( 1, 256 ) ;
    for i = 1: h   
        for j = 1: w
         RNumPixel( 1, R( i, j) + 1) = RNumPixel( 1, R( i, j) + 1) + 1;
        end    
    end
 
    %����Ҷȷֲ��ܶ�
    RProbPixel = zeros( 1, 256 ) ;
    for i = 1 : 256
        RProbPixel ( 1, i ) = RNumPixel( i ) / ( w*h*1.0 ) ;
    end

    %�����ۼ�ֱ��ͼ�ֲ�
    RSumPixel =  double( zeros(1, 256) ) ;

    for i = 1 : 256
        if i ==1 
            RSumPixel ( i ) = RProbPixel (i) ;
        else       
            RSumPixel (i) = RSumPixel (i-1) + RProbPixel ( i ) ;
        end  
    end

    %�ۼƷֲ�ȡ��
    RSumPixel  = uint8( 255 .* RSumPixel +0.5 ) ;

    %�ԻҶ�ֵ����ӳ��
    EquaImage = zeros( h, w ) ;
    for i = 1 : h
        for j = 1 : w 
            EquaImage( i, j) = RSumPixel ( R( i, j ) +1 );
        end
    end
end%%%%%-------------------------------------------


