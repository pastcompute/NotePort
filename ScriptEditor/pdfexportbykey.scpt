JsOsaDAS1.001.00bplist00�Vscriptom ( f u n c t i o n ( ) { 
 ' u s e   s t r i c t ' 
 O b j C . i m p o r t ( ' F o u n d a t i o n ' ) 
 c o n s t   c u r r e n t A p p   =   A p p l i c a t i o n . c u r r e n t A p p l i c a t i o n ( ) ; 
 c u r r e n t A p p . i n c l u d e S t a n d a r d A d d i t i o n s   =   t r u e ; 
 c o n s t   d e s k t o p F o l d e r   =   ` $ { c u r r e n t A p p ( " d e s k t o p " ) } ` ; 
 c o n s t   d o c u m e n t s F o l d e r   =   c u r r e n t A p p . p a t h T o ( " d o c u m e n t s   f o l d e r " ,   { f r o m :   " u s e r   d o m a i n " ,   a s :   " a l i a s " } ) . t o S t r i n g ( ) 
 c o n s o l e . l o g ( d o c u m e n t s F o l d e r ) 
 c o n s t   N o t e s   =   A p p l i c a t i o n ( ' N o t e s ' ) 
 
 c o n s t   s e l e c t i o n   =   N o t e s . s e l e c t i o n ( ) 
 c o n s t   n s   =   s e l e c t i o n . l e n g t h 
 c o n s o l e . l o g ( ` S e l e c t e d   n o t e   c o u n t   $ { n s } ` ) 
 
 c o n s t   n o t e   =   s e l e c t i o n [ 0 ] 
 
 / /   B o r r o w e d   f r o m   h t t p s : / / f o r u m . k e y b o a r d m a e s t r o . c o m / t / w h y - d o - w e - c o d e - j x a - s c r i p t s - u s i n g - c l o s u r e s / 4 7 3 9 
 c o n s t   F i l e U t i l s   =   ( f u n c t i o n ( )   { 
         r e t u r n   { 
                 f i l e E x i s t s :   f u n c t i o n ( p a t h )   { 
                         c o n s t   r e s u l t   =   t h i s . g e t F i l e O r F o l d e r E x i s t s ( p a t h ) ; 
                         r e t u r n   r e s u l t . e x i s t s   & &   r e s u l t . i s F i l e ; 
                 } , 
 
                 g e t F i l e O r F o l d e r E x i s t s :   f u n c t i o n ( p a t h )   { 
 	 	 	 c o n s o l e . l o g ( ` C h e c k   e x i s t s :   $ { p a t h } ` ) 
                         c o n s t   i s D i r e c t o r y   =   R e f ( ) ; 
                         c o n s t   e x i s t s   =   $ . N S F i l e M a n a g e r . d e f a u l t M a n a g e r . f i l e E x i s t s A t P a t h I s D i r e c t o r y ( p a t h ,   i s D i r e c t o r y ) ; 
 	 	 	 c o n s o l e . l o g ( ` C h e c k   e x i s t s :   $ { p a t h }   - - >   $ { e x i s t s } ` ) 
                         r e t u r n   { 
                                 e x i s t s :   e x i s t s , 
                                 i s F i l e :   i s D i r e c t o r y [ 0 ]   ! = =   1 
                         } ; 
                 } 
         } ; 
 } ) ( ) ; 
 
 / / c o n s o l e . l o g ( N o t e s . a p p l i c a t i o n . v e r s i o n ) 
 / /   N o t e s . q u i t ( ) 
 
 / / N o t e s . p r i n t ( n o t e ) 
 / / n o t e . p r i n t ( ) 
 / / N o t e s . p r i n t ( n o t e ( ) ) 
 
 c o n s t   s e A p p   =   A p p l i c a t i o n ( " S y s t e m   E v e n t s " ) 
 N o t e s . a c t i v a t e ( ) 
 d e l a y ( 0 . 6 ) 
 c o n s t   o P r o c e s s   =   s e A p p . p r o c e s s e s . w h o s e ( { f r o n t m o s t :   t r u e } ) [ 0 ] 
 c o n s o l e . l o g ( o P r o c e s s . d i s p l a y e d N a m e ( ) ) 
 
 c o n s t   f i l e M e n u   =   o P r o c e s s . m e n u B a r s [ 0 ] . m e n u B a r I t e m s . b y N a m e ( ' F i l e ' ) 
 / / c o n s t   e x p o r t M e n u   =   f i l e M e n u . m e n u s [ 0 ] . m e n u I t e m s . b y N a m e ( ' C l o s e ' ) 
 / / c o n s t   e x p o r t M e n u   =   f i l e M e n u . m e n u s [ 0 ] . m e n u I t e m s . b y N a m e ( ' E x p o r t   a s   P D F ' ) 
 / / c o n s t   m   =   f i l e M e n u . m e n u s [ 0 ] . m e n u I t e m s 
 / / f o r   ( l e t   n   =   0 ;   n   <   m . l e n g t h ;   n + + )   { 
 / /   c o n s o l e . l o g ( m [ n ] . n a m e ( ) ) 
   / /   F F S   t h e y   d o n t   a l l   h a v e   a   n a m e ,   a n d   s o m e   s h o w   a s   n e s t e d   F U C K 
   / /   I n d e e d   i t   d o e s n t   e v e n   m a t c h   t h e   f u c k i n g   m e n u 
   / /   i t   s e e m s   w e   n e e d   a   d e l a y   o r   i t   g e t s   S a f a r i s   o r   S c r i p t   E d i t o r s 
 / / } 
 
 / / o o k a y ,   m a g i c   t h r e e   d o t s 
 c o n s t   e x p o r t M e n u   =   f i l e M e n u . m e n u s [ 0 ] . m e n u I t e m s . b y N a m e ( ' E x p o r t   a s   P D F & ' ) 
 e x p o r t M e n u . c l i c k ( ) 
 
 / /   N o w ,   h o w   d o   w e   c l i c k   o n   t h e   d i a l o g   t h a t   p o p p e d   u p ?   S e n d   E N T E R 
 / /   T h e s e   d e l a y s   a r e   f i n n i c k y 
 d e l a y ( 0 . 6 ) 
 / /   h t t p s : / / j x a - e x a m p l e s . a k j e m s . c o m 
 / /   h t t p s : / / f o r u m . k e y b o a r d m a e s t r o . c o m / t / h o w - t o - u s e - j x a - w i t h - s y s t e m - e v e n t s - a p p / 6 3 4 1 / 3 
 / /   h t t p s : / / e a s t m a n r e f e r e n c e . c o m / c o m p l e t e - l i s t - o f - a p p l e s c r i p t - k e y - c o d e s 
 / /   1 .   I t   s t a r t s   w i t h   t h e   c u r s o r   i n   t h e   f i l e n a m e ,   s o   l e t s   p r e s s   C o m m a n d + A   t o   g r a b   i t   a l l 
 s e A p p . k e y s t r o k e ( ' a ' ,   { u s i n g :   ' c o m m a n d   d o w n ' } ) 
 
 / / s e A p p . k e y D o w n ( ' e C m d ' ) ;   / /   t h i s   a c t u a l l y   t y p e s .   W T F 
 / / s e A p p . k e y D o w n ( 5 6 ) ;   / /   c o m m a n d 
 / / s e A p p . k e y s t r o k e ( ' a ' ) 
 / / s e A p p . k e y U p ( 5 6 ) ; 
 
 d e l a y ( 0 . 1 ) 
 
 / /   C o p y   t o   c l i p b o a r d 
 s e A p p . k e y s t r o k e ( ' c ' ,   { u s i n g :   ' c o m m a n d   d o w n ' } ) 
 d e l a y ( 0 . 1 ) 
 
 c o n s t   c l i p C o n t e n t s   =   c u r r e n t A p p . t h e C l i p b o a r d ( ) 
 
 / / c o n s o l e . l o g ( o P r o c e s s . p r o p e r t i e s ( ) ) 
 / /   h t t p s : / / s u p p o r t . a p p l e . c o m / e n - a u / H T 2 0 1 2 3 6 
 / /   W h a t   a b o u t   t h e   p a t h ? 
 / /   S h i f t   +   C o m m a n d   +   G   w i l l   l e t   u s   t y p e   a   p a t h 
 
 c o n s t   d e s t D i r   =   d o c u m e n t s F o l d e r   +   ' / _ d e m o d i r ' 
 c u r r e n t A p p . d o S h e l l S c r i p t ( ` m k d i r   - p   ' $ { d e s t D i r } ' ` ) 
 l e t   g o o d   =   f a l s e 
 t r y   { 
 	 s e A p p . k e y D o w n ( 5 5 ) ;   / /   c o m m a n d 
 	 s e A p p . k e y D o w n ( 5 6 ) ;   / /   s h i f t 
 	 s e A p p . k e y D o w n ( 5 )   / /   g 
 	 g o o d   =   t r u e 
 }   c a t c h   ( e )   { 
 } 
 s e A p p . k e y U p ( 5 ) 
 s e A p p . k e y U p ( 5 5 ) ; 
 s e A p p . k e y U p ( 5 6 ) ; 
 i f   ( g o o d )   { 
 	 d e l a y ( 0 . 2 ) 
   	 / /   t h i s   i s   t o o   f a s t   d u e   t o   a u t o c o m p l e t e   - - >   s e A p p . k e y s t r o k e ( ` $ { d e s t D i r } ` ) 
 	 f o r   ( l e t   c   o f   d e s t D i r )   {   
 	 s e A p p . k e y s t r o k e ( c ) 
 	 d e l a y ( 0 . 0 1 ) 
 	 } 
 
 	 / /   E N T E R 
 	 s e A p p . k e y D o w n ( 3 6 )   
 	 s e A p p . k e y U p ( 3 6 )   
 	 d e l a y ( 0 . 0 2 ) 
 
 } 
 
 f u n c t i o n   g e t E x t ( f i l e N a m e )   { 
 	 i f   ( ! f i l e N a m e )   r e t u r n   n u l l 
 	 c o n s t   r   =   f i l e N a m e . s p l i t ( ' . ' ) 
 	 i f   ( r . l e n g t h   <   2 )   r e t u r n   " " 
 	 r e t u r n   r . r e v e r s e ( ) [ 0 ] 	 
 } 
 
 / /   F I X M E   T O D O   c h e c k   f o r   b o g u s   c h a r a c t e r s 
 l e t   d e s t F i l e P a t h   = ` $ { d e s t D i r } / $ { c l i p C o n t e n t s } ` 
 c o n s t   f r   =   c l i p C o n t e n t s . s p l i t ( ' . ' ) 
 l e t   f b   =   c l i p C o n t e n t s 
 l e t   e x t   =   ' ' 
 i f   ( f r . l e n g t h   >   1 )   { 
     f b   =   f r . s l i c e ( 0 ,   - 1 ) . j o i n ( ' . ' ) 
     e x t   =   ' . '   +   f r . r e v e r s e ( ) [ 0 ] 
 } 
 l e t   f n   =   1 
 l e t   f i l e P a t h T r y   =   d e s t F i l e P a t h 
 l e t   p a s t e r   =   n u l l 
 c o n s o l e . l o g ( ` $ { f i l e P a t h T r y } ;   $ { f b } ;   $ { e x t } ` ) 
 w h i l e   ( F i l e U t i l s . f i l e E x i s t s ( f i l e P a t h T r y ) )   { 
 	 c o n s o l e . l o g ( " t r y   c o p y   "   +   f n ) 
 	 p a s t e r   =   ` $ { f b }   ( C o p y   $ { f n } ) $ { e x t } ` 
 	 f i l e P a t h T r y   =   P a t h ( ` $ { d e s t D i r } / $ { p a s t e r } ` ) . t o S t r i n g ( ) 
 	 f n   =   f n   +   1 
 	 c o n s o l e . l o g ( " t r y   c o p y   "   +   f i l e P a t h T r y ) 
 } 
 c o n s o l e . l o g ( " t r y   a n d   "   +   f i l e P a t h T r y ) 
 / /   P a s t e   i t   b a c k   i n   n o w 
 i f   ( p a s t e r )   { 
 	 d e l a y ( 0 . 1 ) 
 	 s e A p p . k e y s t r o k e ( ' a ' ,   { u s i n g :   ' c o m m a n d   d o w n ' } ) 
 	 d e l a y ( 0 . 1 ) 
 	 f o r   ( l e t   c   o f   p a s t e r )   { 
 	 	 s e A p p . k e y s t r o k e ( c ) 
 	 	 d e l a y ( 0 . 0 1 ) 
 	 } 
 } 
 / /   E N T E R 
 
 d e l a y ( 0 . 0 5 ) 
 s e A p p . k e y D o w n ( 3 6 )   
 s e A p p . k e y U p ( 3 6 )   
 d e l a y ( 0 . 0 2 ) 
 
 
 / / c u r r e n t A p p . d i s p l a y D i a l o g ( ` $ { f i l e P a t h T r y } ` ,   { b u t t o n s :   [ " C o n t i n u e " ] } ) 
 
 / /   F u c k   w h y   d o e s   t h e   d i a l o g   c o m e   u p   a l r e a d y 
 / /   d e l a y ( 0 . 2 ) ;   c u r r e n t A p p . d i s p l a y D i a l o g ( ` $ { c l i p C o n t e n t s } ` ,   { b u t t o n s :   [ " C o n t i n u e " ] } ) 
 
 / /   h t t p s : / / s t a c k o v e r f l o w . c o m / q u e s t i o n s / 3 2 0 2 1 8 7 0 / s e n d i n g - s y s t e m - e v e n t s - k e y - d o w n - u p - u s i n g - j x a 
 / / s e A p p . k e y s t r o k e ( ' \ n ' ) 
 i f   ( f a l s e )   { 
 s e A p p . k e y D o w n ( 3 6 )   
 s e A p p . k e y U p ( 3 6 )   
 } 
 / /   F u c k   i t   d o e s n t   t o   t a b b i n g   l i k e   W i n d o w s / .   F u c k   m e .   E S C   w o r k s   t h o u g h . . . 
 / / d e l a y ( 0 . 1 )   / /   i n   c a s e   o f   r e p l a c e ? 
 / / s e A p p . k e y D o w n ( 3 6 )   
 / / s e A p p . k e y U p ( 3 6 )   
 
 / /   I n   t h e o r y   w e   c a n   g e t   r e a l   f u n k y   n o w   t h o u g h .   D e t e c t   t h e   n a m e   i t   w i l l   s a v e   a s ,   t h e n   s e e   i f   i t   e x i s t s ,   a n d   i f   s o ,   a d d   a   ( 1 ) ,   a l l   u s i n g   t h e   k e y b o a r d 
 
 c o n s o l e . l o g ( ' t a d a ' ) 
 
 / /   G l i t c h   -   t e s t   b e f o r e h a n d   i f   f i l e   e x i s t s ? 
 
 } ) ( )                              (�jscr  ��ޭ