JsOsaDAS1.001.00bplist00�Vscripto ( f u n c t i o n ( ) { 
 ' u s e   s t r i c t ' 
 O b j C . i m p o r t ( ' F o u n d a t i o n ' ) 
 c o n s t   c u r r e n t A p p   =   A p p l i c a t i o n . c u r r e n t A p p l i c a t i o n ( ) 
 c u r r e n t A p p . i n c l u d e S t a n d a r d A d d i t i o n s   =   t r u e 
 c o n s t   N o t e s   =   A p p l i c a t i o n ( ' N o t e s ' ) 
 c o n s t   S y s t e m E v e n t s   =   A p p l i c a t i o n ( " S y s t e m   E v e n t s " ) 
 
 c o n s t   g l o b a l s   =   {   } 
 c o n s t   M A X _ F O L D E R _ D E P T H   =   1 6 
 
 c o n s t   C o n t a i n e r K i n d   =   O b j e c t . f r e e z e ( { 
 	 A c c o u n t :   S y m b o l ( " A c c o u n t " ) , 
 	 F o l d e r :   S y m b o l ( " F o l d e r " ) , 
 	 U n k n o w n :   S y m b o l ( " U n k n o w n " ) , 
 } ) 
 
 f u n c t i o n   r e p l a c e r ( k ,   v )   { 
 	 / / c o n s o l e . l o g ( ` $ { k }   ~ >   $ { t y p e o f   v } ` ) 
 	 i f   ( t y p e o f   v   = = =   ' s y m b o l ' )   { 
 	 	 r e t u r n   v . d e s c r i p t i o n 
 	 } 
 	 r e t u r n   v 
 } 
 
 f u n c t i o n   g e t C o n t a i n e r K i n d ( i t e m )   { 
 	 c o n s t   r   =   i t e m   & &   i t e m . i d   & &   i t e m . i d . s p l i t ( ' / ' ) 
 	 i f   ( r   & &   r . l e n g t h   >   4   & &   r [ 0 ]   = = =   ' x - c o r e d a t a : '   & &   r [ 3 ]   = = =   ' I C A c c o u n t ' )   { 
 	 	 r e t u r n   C o n t a i n e r K i n d . A c c o u n t 
 	 }   e l s e   i f   ( r   & &   r . l e n g t h   >   4   & &   r [ 0 ]   = = =   ' x - c o r e d a t a : '   & &   r [ 3 ]   = = =   ' I C F o l d e r ' )   { 
 	 	 r e t u r n   C o n t a i n e r K i n d . F o l d e r 
 	 }   e l s e   { 
 	 	 r e t u r n   C o n t a i n e r K i n d . U n k n o w n 
 	 } 
 } 
 
 f u n c t i o n   g e t C o n t a i n e r I n f o ( c o n t a i n e r R e f )   { 
 	 c o n s t   r e s u l t   =   { 
 	 	 i d :   c o n t a i n e r R e f . i d ( ) , 
 	 	 n a m e :   c o n t a i n e r R e f . n a m e ( ) , 
 	 	 p a r e n t R e f :   n u l l 
 	 } 
 	 r e s u l t . k i n d   =   g e t C o n t a i n e r K i n d ( r e s u l t ) 
 	 i f   ( r e s u l t . k i n d   = = =   C o n t a i n e r K i n d . F o l d e r )   { 
 	 	 r e s u l t . p a r e n t R e f   =   c o n t a i n e r R e f . c o n t a i n e r ( ) 
 	 }   / /   e l s e ,   a c c o u n t s   w o n t   h a v e   a   p a r e n t 
 	 / / c o n s o l e . l o g ( J S O N . s t r i n g i f y ( r e s u l t ,   r e p l a c e r ,   2 ) ) 
 	 r e t u r n   r e s u l t 
 } 
 
 c o n s t   F i l e U t i l s   =   ( f u n c t i o n ( )   { 
         r e t u r n   { 
 	 	 s a n i t i s e P a t h ( p a t h )   { 
 	 	 	 r e t u r n   p a t h . r e p l a c e A l l ( / [ : / & < > | \ * \ ? \ \ \ / " ' ] / g ,   " _ " ) 
 	 	 } , 
 	 	 f i l e E x t e n s i o n ( f i l e N a m e )   { 
 	 	 	 i f   ( ! f i l e N a m e )   r e t u r n   n u l l 
 	 	 	 c o n s t   r   =   f i l e N a m e . s p l i t ( ' . ' ) 
 	 	 	 i f   ( r . l e n g t h   <   2 )   r e t u r n   " " 
 	 	 	 r e t u r n   r . r e v e r s e ( ) [ 0 ]   / /   t h i s   m e t h o d   f e e l s   r a t h e r   i n e f f i c i e n t . . . 
 	 	 } , 
                 f i l e E x i s t s :   f u n c t i o n ( p a t h )   { 
                         c o n s t   r e s u l t   =   t h i s . g e t F i l e O r F o l d e r E x i s t s ( p a t h ) ; 
                         r e t u r n   r e s u l t . e x i s t s   & &   r e s u l t . i s F i l e ; 
                 } , 
                 g e t F i l e O r F o l d e r E x i s t s :   f u n c t i o n ( p a t h )   { 
 	 	 	 / /   c o n s o l e . l o g ( ` C h e c k   e x i s t s :   $ { p a t h } ` ) 
                         c o n s t   i s D i r e c t o r y   =   R e f ( ) ; 
                         c o n s t   e x i s t s   =   $ . N S F i l e M a n a g e r . d e f a u l t M a n a g e r . f i l e E x i s t s A t P a t h I s D i r e c t o r y ( p a t h ,   i s D i r e c t o r y ) ; 
 	 	 	 / /   c o n s o l e . l o g ( ` C h e c k   e x i s t s :   $ { p a t h }   - - >   $ { e x i s t s } ` ) 
                         r e t u r n   { 
                                 e x i s t s :   e x i s t s , 
                                 i s F i l e :   i s D i r e c t o r y [ 0 ]   ! = =   1 
                         } ; 
                 } 
         } ; 
 } ) ( ) ; 
 
 / /   H e l p e r   f u n c t i o n   t o   e s c a p e   t h i n g s   t h a t   w i l l   g o   i n   s h e l l   s i n g l e   q u o t e   s t r i n g s ,   t h a t   a r e   n o t   f i l e n a m e s 
 f u n c t i o n   s a n i t i s e V a l u e ( s )   { 
 	 c o n s t   r e s u l t   =   ! ! s   ?   s 
 	 	 . r e p l a c e ( / ' / g ,   " ' \ " ' \ " ' " ) 
 	 	 . r e p l a c e ( / \ ( / g ,   " ' \ " ( \ " ' " )   :   s 
 	 r e t u r n   r e s u l t   / /   r e m e m b e r ,   r e t u r n   d o t   l i n e s   c a n t   b r e a k . . . 
 } 
 
 f u n c t i o n   t r a c e ( m e s s a g e )   { 
 	 c u r r e n t A p p . d o S h e l l S c r i p t ( ` e c h o   ' $ { s a n i t i s e V a l u e ( m e s s a g e ) } '   > >   ' $ { g l o b a l s . l o g f i l e } ' ` ) 
 } 
 
 / /   W e   h a d   s i t u a t i o n s   w h e r e   i f   t h e   s c r i p t   i s   a b o r t e d   o r   t h r o w s   a n   e x c e p t i o n ,   a   k e y   c a n   b e   s t u c k   d o w n   ( l i k e ,   s e r i o u s l y ,   A p p l e ! ) 
 / /   S o   m a k e   s u r e   t h e   k e y s   a l l   c o m e   b a c k   u p ,   r e g a r d l e s s   o f   w h a t   h a p p e n s 
 f u n c t i o n   s a f e C o m m a n d P r e s s ( s e q u e n c e )   { 
 	 t r y   { 
 	 	 f o r   ( c o n s t   s   o f   s e q u e n c e )   { 
 	 	 	 S y s t e m E v e n t s . k e y D o w n ( s ) 
 	 	 } 
 	 }   c a t c h   ( e )   { } 
 	 f o r   ( c o n s t   s   o f   s e q u e n c e . r e v e r s e ( ) )   { 
 	 	 S y s t e m E v e n t s . k e y U p ( s ) 
 	 } 	 
 } 
 
 f u n c t i o n   e x p o r t S l o w P d f ( o P r o c e s s ,   d e s t D i r )   { 
 	 c o n s t   f i l e M e n u   =   o P r o c e s s . m e n u B a r s [ 0 ] . m e n u B a r I t e m s . b y N a m e ( ' F i l e ' ) 
 	 c o n s t   e x p o r t M e n u   =   f i l e M e n u . m e n u s [ 0 ] . m e n u I t e m s . b y N a m e ( ' E x p o r t   a s   P D F & ' ) 
 	 e x p o r t M e n u . c l i c k ( ) 
 	 d e l a y ( 0 . 6 ) 
 	 
 	 / /   C o p y   w h a t e v e r   t h e   c u r r e n t   e x p o r t   s u g g e s t e d   n a m e   i s 
 	 S y s t e m E v e n t s . k e y s t r o k e ( ' a ' ,   { u s i n g :   ' c o m m a n d   d o w n ' } ) 
 	 d e l a y ( 0 . 1 ) 
 	 S y s t e m E v e n t s . k e y s t r o k e ( ' c ' ,   { u s i n g :   ' c o m m a n d   d o w n ' } ) 
 	 d e l a y ( 0 . 1 ) 
 	 c o n s t   c l i p C o n t e n t s   =   c u r r e n t A p p . t h e C l i p b o a r d ( ) 
 	 
 	 / /   C m n d + S h i f t + g   t o   e x p a n d   t h e   f o l d e r   s e l e c t o r 
 	 s a f e C o m m a n d P r e s s ( [ 5 5 ,   5 6 ,   5 ] )   / /   c o m m a n d ,   s h i f t ,   g 
 
 	 / /   t y p e   i n   t h e   c o r r e c t   d i r e c t o r y ,   t h e n   p r e s s   E N T E R 
 	 d e l a y ( 0 . 2 )   / /   s i g h 
 	 f o r   ( l e t   c   o f   d e s t D i r )   {   
 	 	 S y s t e m E v e n t s . k e y s t r o k e ( c ) 
 	 	 d e l a y ( 0 . 0 1 )   / /   w e   s e e m   t o   b e   a b l e   t o   c o p e   w i t h   m a k i n g   t h i s   1 0   m s e c 
 	 } 
 	 s a f e C o m m a n d P r e s s ( [ 3 6 ] ) 
 	 
 	 / /   N o w   c o m b i n e   t h e   s u g g e s t e d   f i l e n a m e   w i t h   t h e   c l i p b o a r d   s o   w e   c a n   t e s t   i f   i t   a l r e a d y   e x i s t s . . . 
 	 / /   I f   i t   d o e s   t h e n   w e   w i l l   a d d   a   ' c o p y - 1 '   e t c   b e f o r e   t h e   e x t e n s i o n . . . 
 	 l e t   d e s t F i l e P a t h   = ` $ { d e s t D i r } / $ { c l i p C o n t e n t s } ` 
 	 c o n s t   f r   =   c l i p C o n t e n t s . s p l i t ( ' . ' ) 
 	 l e t   f b   =   c l i p C o n t e n t s 
 	 l e t   e x t   =   ' ' 
 	 i f   ( f r . l e n g t h   >   1 )   { 
 	 	 f b   =   f r . s l i c e ( 0 ,   - 1 ) . j o i n ( ' . ' ) 
 	 	 e x t   =   ' . '   +   f r . r e v e r s e ( ) [ 0 ] 
 	 } 
 	 l e t   f n   =   1 
 	 l e t   f i l e P a t h T r y   =   d e s t F i l e P a t h 
 	 l e t   p a s t e r   =   n u l l 
 	 w h i l e   ( F i l e U t i l s . f i l e E x i s t s ( f i l e P a t h T r y ) )   { 
 	 	 p a s t e r   =   ` $ { f b }   ( C o p y   $ { f n } ) $ { e x t } ` 
 	 	 f i l e P a t h T r y   =   P a t h ( ` $ { d e s t D i r } / $ { p a s t e r } ` ) . t o S t r i n g ( ) 
 	 	 f n   =   f n   +   1 
 	 } 
 	 i f   ( p a s t e r )   { 
 	 	 d e l a y ( 0 . 1 ) 
 	 	 S y s t e m E v e n t s . k e y s t r o k e ( ' a ' ,   { u s i n g :   ' c o m m a n d   d o w n ' } ) 
 	 	 d e l a y ( 0 . 1 ) 
 	 	 f o r   ( l e t   c   o f   p a s t e r )   { 
 	 	 	 S y s t e m E v e n t s . k e y s t r o k e ( c ) 
 	 	 	 d e l a y ( 0 . 0 1 ) 
 	 	 } 
 	 } 
 	 / /   A n d   p r e s s   E N T E R   t o   d o   i t 
 	 d e l a y ( 0 . 0 5 ) 
 	 s a f e C o m m a n d P r e s s ( [ 3 6 ] ) 
 } 
 
 / /   P r o c e s s   a l l   a c c o u n t s   c o n n e c t e d ,   o r   ( T O D O )   a p p l y   a   f i l t e r   a n d   o n l y   p r o c e s s   s o m e   o r   o n e 
 f u n c t i o n   e n u m e r a t e A c c o u n t s ( )   { 
 	 c o n s t   a c c o u n t s R e f   =   N o t e s . a c c o u n t s 
 	 c o n s t   n u m A c c o u n t s   =   a c c o u n t s R e f . l e n g t h 
 	 
 	 g l o b a l s . p r o c e s s e d   =   { 
 	 	 a c c o u n t s :   0 , 
 	 	 f o l d e r s :   0 , 
 	 	 n o t e s S e e n :   0 , 
 	 } 
 
 	 f o r   ( l e t   n = 0 ;   n   <   n u m A c c o u n t s ;   n + + )   { 
 	 	 c o n s t   a c c o u n t R e f   =   N o t e s . a c c o u n t s [ n ] 
 	 	 c o n s t   a c c o u n t N a m e   =   a c c o u n t R e f . n a m e ( ) 
 	 	 
 	 	 g l o b a l s . p r o c e s s e d . a c c o u n t s   + + 
 
 	 	 t r a c e ( ` P r o c e s s i n g   a c c o u n t . n a m e = $ { a c c o u n t N a m e } ` ) 
 	 	 P r o g r e s s . d e s c r i p t i o n   =   ` A c c o u n t   $ { a c c o u n t N a m e } & ` 
 	 	 
 	 	 / /   N o t e   t h a t   e m p t y   f o l d e r s   w o n t   b e   s e e n   w h e n   w e   d o   i t   t h i s   w a y 
 	 	 / /   P e r h a p s   t h e r e   i s   a n   o p p o r t u n i t y   t o   o p t i m i s e   b y   c o m p u t i n g   t h e   f o l d e r   p a r e n t   p a t h   o n c e . . . 
 
 	 	 c o n s t   f o l d e r s R e f   =   a c c o u n t R e f . f o l d e r s 
 	 	 c o n s t   n u m F o l d e r s   =   f o l d e r s R e f . l e n g t h 
 	 	 f o r   ( l e t   m = 0 ;   m   <   n u m F o l d e r s ;   m + + )   { 
 	 	 	 c o n s t   f o l d e r R e f   =   f o l d e r s R e f [ m ] 
 	 	 	 c o n s t   f o l d e r N a m e   =   f o l d e r R e f . n a m e ( ) 
 	 	 	 g l o b a l s . p r o c e s s e d . f o l d e r s   + + 
 
 	 	 	 t r a c e ( ` P r o c e s s i n g   a c c o u n t . f o l d e r . n a m e = $ { f o l d e r N a m e } ` ) 
 	 	 	 P r o g r e s s . d e s c r i p t i o n   =   ` A c c o u n t   $ { a c c o u n t N a m e }   f o l d e r   $ { f o l d e r N a m e } & ` 
 	 	 	 
 	 	 	 / /   E m p i r i c a l l y ,   a c c e s s i n g   v i a   a c c o u n t . n o t e s   w i t h   a   s i n g l e   l o o p ,   i s   w a y   s l o w e r   t h a n   b y   e a c h   n o t e s '   f o l d e r 
 	 	 	 c o n s t   n o t e s R e f   =   f o l d e r R e f . n o t e s 
 	 	 	 c o n s t   n u m N o t e s   =   n o t e s R e f . l e n g t h 
 	 	 	 f o r   ( l e t   k = 0 ;   k   <   n u m N o t e s ;   k + + )   { 
 	 	 	 	 c o n s t   n o t e R e f   =   n o t e s R e f [ k ] 
 	 	 	 	 c o n s t   n o t e N a m e   =   n o t e R e f . n a m e ( ) 
 	 	 	 	 g l o b a l s . p r o c e s s e d . n o t e s S e e n   + + 
 	 	 	 	 t r a c e ( ` n o t e . n a m e = $ { n o t e N a m e } ` ) 
 	 	 	 	 P r o g r e s s . a d d i t i o n a l D e s c r i p t i o n   =   ` N o t e   $ { n o t e N a m e } ` 
 	 	 	 
 	 	 	 	 c o n s t   n o t e D a t a   =   { 
 	 	 	 	 	 n o t e R e f :   n o t e R e f , 
 	 	 	 	 	 i d :   n o t e R e f . i d ( ) , 
 	 	 	 	 	 n a m e :   n o t e N a m e , 
 	 	 	 	 	 c r e a t e d :   n o t e R e f . c r e a t i o n D a t e ( ) , 
 	 	 	 	 	 m o d i f i e d :   n o t e R e f . m o d i f i c a t i o n D a t e ( ) , 
 	 	 	 	 	 p a r e n t s :   [ g e t C o n t a i n e r I n f o ( n o t e R e f . c o n t a i n e r ( ) ) ] , 
 	 	 	 	 } 
 	 	 	 	 l e t   n   =   1 
 	 	 	 	 f o r   ( ;   n   <   M A X _ F O L D E R _ D E P T H ;   n + + )   { 
 	 	 	 	 	 l e t   c o n t a i n e r   =   g e t C o n t a i n e r I n f o ( n o t e D a t a . p a r e n t s [ n - 1 ] . p a r e n t R e f ) 
 	 	 	 	 	 n o t e D a t a . p a r e n t s . p u s h ( c o n t a i n e r ) 
 	 	 	 	 	 i f   ( ! c o n t a i n e r . p a r e n t R e f )   {   b r e a k   } 
 	 	 	 	 } 
 	 	 	 	 i f   ( n   >   M A X _ F O L D E R _ D E P T H )   { 
 	 	 	 	 	 t h r o w   ` W e   c a n t   h a n d l e   a   f o l d e r   n e s t   o f   $ { M A X _ F O L D E R _ D E P T H }   l a y e r s   d e e p ! ` 
 	 	 	 	 } 
 	 	 	 	 c o n s t   n o t e P a t h   =   n o t e D a t a . p a r e n t s . m a p ( x   = >   F i l e U t i l s . s a n i t i s e P a t h ( x . n a m e ) ) . r e v e r s e ( ) . j o i n ( ' / ' ) 
 	 	 	 	 t r a c e ( ` n o t e . p a t h = $ { n o t e P a t h } ` ) 
 	 	 	 	 t r a c e ( ` n o t e . i d = $ { n o t e D a t a . i d } ` ) 
 	 	 	 	 
 	 	 	 	 c o n s t   d e s t D i r   =   ` $ { g l o b a l s . o u t p u t F o l d e r } / $ { n o t e P a t h } ` 
 	 	 	 	 c u r r e n t A p p . d o S h e l l S c r i p t ( ` m k d i r   - p   ' $ { d e s t D i r } ' ` ) 
 
 	 	 	 	 N o t e s . s h o w ( n o t e R e f ) 
 	 	 	 	 
 	 	 	 	 e x p o r t S l o w P d f ( g l o b a l s . o P r o c e s s ,   d e s t D i r ) 
 	 	 	 } 
 	 	 } 
 	 } 
 } 
 
 f u n c t i o n   s t a r t ( )   { 
 	 g l o b a l s . e x p o r t e d C o u n t   =   0 
 	 g l o b a l s . e r r o r C o u n t   =   0 
 	 g l o b a l s . o u t p u t F o l d e r   =   c u r r e n t A p p . c h o o s e F o l d e r ( { w i t h P r o m p t : " C h o o s e   d e s t i n a t i o n   f o l d e r & " } ) 
 	 c o n s t   n o w   =   n e w   D a t e ( ) . t o T i m e S t r i n g ( ) 
 	 g l o b a l s . l o g f i l e   =   g l o b a l s . o u t p u t F o l d e r . t o S t r i n g ( )   + ` / l o g - $ { F i l e U t i l s . s a n i t i s e P a t h ( n o w ) } . t x t ` 
 	 t r a c e ( ` P r o c e s s i n g   n o w = $ { n o w } ` ) 
 
 	 N o t e s . a c t i v a t e ( ) 
 	 d e l a y ( 0 . 6 ) 
 	 g l o b a l s . o P r o c e s s   =   S y s t e m E v e n t s . p r o c e s s e s . w h o s e ( { f r o n t m o s t :   t r u e } ) [ 0 ] 
 
 	 e n u m e r a t e A c c o u n t s ( ) ; 
 } 
 
 t r y   { 
 	 s t a r t ( ) 
 }   f i n a l l y   { 
 } 
 
 t r a c e ( ` P r o c e s s e d   a c c o u n t s = $ { g l o b a l s . p r o c e s s e d . a c c o u n t s }   f o l d e r s = $ { g l o b a l s . p r o c e s s e d . f o l d e r s }   n o t e s S e e n = $ { g l o b a l s . p r o c e s s e d . n o t e s S e e n } ` ) 
 
 / / t r a c e ( ` P r o c e s s e d   e x p o r t e d = $ { g l o b a l s . e x p o r t e d C o u n t }   e r r o r s = $ { g l o b a l s . e r r o r C o u n t } ` ) 
 
 } ) ( ) 
                              <"jscr  ��ޭ