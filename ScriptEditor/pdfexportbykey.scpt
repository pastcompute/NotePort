JsOsaDAS1.001.00bplist00�Vscripto� ( f u n c t i o n ( ) { 
 ' u s e   s t r i c t ' 
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
 / / c o n s o l e . l o g ( N o t e s . a p p l i c a t i o n . v e r s i o n ) 
 / /   N o t e s . q u i t ( ) 
 
 / / N o t e s . p r i n t ( n o t e ) 
 / / n o t e . p r i n t ( ) 
 / / N o t e s . p r i n t ( n o t e ( ) ) 
 
 c o n s t   s e A p p   =   A p p l i c a t i o n ( " S y s t e m   E v e n t s " ) 
 N o t e s . a c t i v a t e ( ) 
 d e l a y ( 0 . 1 ) 
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
 d e l a y ( 1 . 2 ) 
 / /   h t t p s : / / s t a c k o v e r f l o w . c o m / q u e s t i o n s / 3 2 0 2 1 8 7 0 / s e n d i n g - s y s t e m - e v e n t s - k e y - d o w n - u p - u s i n g - j x a 
 / / s e A p p . k e y s t r o k e ( ' \ n ' ) 
 s e A p p . k e y D o w n ( 3 6 )   
 s e A p p . k e y U p ( 3 6 )   
 
 / /   F u c k   i t   d o e s n t   t o   t a b b i n g   l i k e   W I n d o w s / .   F u c k   m e .   E S C   w o r k s   t h o u g h . . . 
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
 } ) ( )                              �jscr  ��ޭ