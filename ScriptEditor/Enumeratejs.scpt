JsOsaDAS1.001.00bplist00�Vscripto< / /   H e l p f u l   r e f e r e n c e s : 
 / /   h t t p s : / / w w w . g a l v a n i s t . c o m / p o s t s / 2 0 2 0 - 0 3 - 2 8 - j x a _ n o t e s / 
 / /   h t t p s : / / b r i a n l o v i n . c o m / h n / 3 1 5 7 9 4 3 5 
 / /   h t t p s : / / g i s t . g i t h u b . c o m / J M i c h a e l T X / d 2 9 a d a a 1 8 0 8 8 5 7 2 c e 6 d 4 
 / /   h t t p s : / / d e v e l o p e r . a p p l e . c o m / l i b r a r y / m a c / r e l e a s e n o t e s / I n t e r a p p l i c a t i o n C o m m u n i c a t i o n / R N - J a v a S c r i p t F o r A u t o m a t i o n / A r t i c l e s / O S X 1 0 - 1 0 . h t m l 
 / /   h t t p s : / / d e v e l o p e r . a p p l e . c o m / l i b r a r y / a r c h i v e / d o c u m e n t a t i o n / L a n g u a g e s U t i l i t i e s / C o n c e p t u a l / M a c A u t o m a t i o n S c r i p t i n g G u i d e / M a k e a S y s t e m - W i d e S e r v i c e . h t m l # / / a p p l e _ r e f / d o c / u i d / T P 4 0 0 1 6 2 3 9 - C H 4 6 - S W 1 
 / /   h t t p s : / / s t a c k o v e r f l o w . c o m / q u e s t i o n s / 4 8 2 5 5 9 4 3 / a c c e s s i n g - p r o p e r t i e s - o f - o b j e c t - u s i n g - j x a 
 / /   h t t p s : / / s t a c k o v e r f l o w . c o m / a / 4 8 2 7 1 6 8 6 / 2 7 7 2 4 6 5 
 
 / /   W A R N I N G 
 / /   R U N 
 
 c o n s t   c u r r e n t A p p   =   A p p l i c a t i o n . c u r r e n t A p p l i c a t i o n ( ) ; 
 c u r r e n t A p p . i n c l u d e S t a n d a r d A d d i t i o n s   =   t r u e ; 
 
 c o n s t   d e s k t o p F o l d e r   =   ` $ { c u r r e n t A p p ( " d e s k t o p " ) } ` ; 
 
 c o n s t   g l o b a l s   =   {   } 
 
 c o n s t   G o o d A t t a c h m e n t s   =   [ ' p d f ' ,   ' h e i c ' ,   ' p n g ' ,   ' j p e g ' ] 
 
 c o n s t   N o t e s   =   A p p l i c a t i o n ( ' N o t e s ' ) 
 
 t r y   { 
 	 s t a r t ( ) 
 }   f i n a l l y   { 
 	 d e l e t e   N o t e s 
 	 d e l e t e   c u r r e n t A p p 
 } 
 
 f u n c t i o n   s t a r t ( )   { 
 	 g l o b a l s . e x p o r t e d C o u n t   =   0 
 	 g l o b a l s . e r r o r C o u n t   =   0 
 	 g l o b a l s . o u t p u t F o l d e r   =   c u r r e n t A p p . c h o o s e F o l d e r ( { w i t h P r o m p t : " C h o o s e   a   f o l d e r   t o   s a v e   e x p o r t e d   n o t e s   t o " } ) 
 	 / /   a l t :   s y s . p a t h T o ( " d o c u m e n t s   f o l d e r " ,   { f r o m :   " u s e r   d o m a i n " ,   a s :   " a l i a s " } ) . t o S t r i n g ( )   +   ' / b l a h ' ; 
 	 c o n s t   n o w   =   n e w   D a t e ( ) 
 	 g l o b a l s . l o g f i l e   =   g l o b a l s . o u t p u t F o l d e r . t o S t r i n g ( )   + ` / l o g - $ { s a n i t i s e P a t h ( n o w . t o T i m e S t r i n g ( ) ) } . t x t ` 
 	 c u r r e n t A p p . d o S h e l l S c r i p t ( ` e c h o   ' P r o c e s s i n g   n o w = $ { s a n i t i s e V a l u e ( n o w . t o T i m e S t r i n g ( ) ) } '   >   ' $ { g l o b a l s . l o g f i l e } ' ` ) 
 	 e n u m e r a t e A c c o u n t s ( ) ; 
 	 c u r r e n t A p p . d o S h e l l S c r i p t ( ` e c h o   ' P r o c e s s e d   e x p o r t e d = $ { g l o b a l s . e x p o r t e d C o u n t }   e r r o r s = $ { g l o b a l s . e r r o r C o u n t } '   >   ' $ { g l o b a l s . l o g f i l e } ' ` ) 
 } 
 
 / /   N o t e : 
 / /   W h e n   d e b u g g i n g   w i t h   J S O N . s t r i n g i f y ,   s t r i p   o u t   t h e   ' p a r e n t '   o b j e c t s   a s   t h e s e   w i l l   c a u s e   a   r e c u r s i o n ! 
 f u n c t i o n   r e p l a c e r ( k ,   v )   { 
 	 / /   c o n s o l e . l o g ( ` k = $ { k } ,   t = $ { t y p e o f   v } ` ) 
 	 i f   ( k   = = =   ' p a r e n t ' )   {   r e t u r n   u n d e f i n e d   } 
 	 / /   I f   n e c e s s a r y   d o   a d d i t i o n a l   h a n d l i n g   t o   g e t   o t h e r   p r o p e r t i e s   f r o m   a o N o t e ,   a o F o l d e r ,   h e r e 
 	 r e t u r n   v 
 } 
 
 / /   P r o c e s s   a l l   a c c o u n t s   c o n n e c t e d ,   o r   a p p l y   a   f i l t e r   a n d   o n l y   p r o c e s s   s o m e   o r   o n e 
 f u n c t i o n   e n u m e r a t e A c c o u n t s ( )   { 
 	 c o n s t   n u m A c c o u n t s   =   N o t e s . a c c o u n t s . l e n g t h 
 	 f o r   ( l e t   n = 0 ;   n   <   n u m A c c o u n t s ;   n + + )   { 
 	 	 c o n s t   a c c o u n t   =   N o t e s . a c c o u n t s [ n ] 
 	 	 c o n s t   a c c o u n t N a m e   =   a c c o u n t . n a m e ( ) 
 	 	 c o n s o l e . l o g ( ` A c c o u n t :   $ { a c c o u n t N a m e } ` ) ; 
 	 	 / / i f   ( a c c o u n t N a m e   = = =   ' i C l o u d ' )   c o n t i n u e 
 
 	 	 c u r r e n t A p p . d o S h e l l S c r i p t ( ` e c h o   ' P r o c e s s i n g   a c c o u n t . n a m e = $ { s a n i t i s e V a l u e ( a c c o u n t N a m e ) } '   > >   ' $ { g l o b a l s . l o g f i l e } ' ` ) 
 
 	 	 P r o g r e s s . d e s c r i p t i o n   =   ' E n u m e r a t i n g   f o l d e r s & ' 
 	 	 c o n s t   t r e e   =   e n u m e r a t e F o l d e r s ( a c c o u n t ) 
 	 	 P r o g r e s s . d e s c r i p t i o n   =   ' E n u m e r a t i n g   n o t e s & ' 
 	 	 e n u m e r a t e N o t e s ( t r e e ) 
 	 	 / /   c o n s o l e . l o g ( J S O N . s t r i n g i f y ( t r e e ,   r e p l a c e r ,   "     " ) ) 
 
 	 	 P r o g r e s s . d e s c r i p t i o n   =   ' E x p o r t i n g   n o t e s & ' 
 
 	 	 r e c u r s e I t e m s ( t r e e ,   0 ,   ( i t e m ,   l e v e l )   = >   { 
 	 	 	 p r o c e s s N o t e s I n F o l d e r ( i t e m ) 
 	 	 } ,   t r u e ) 
 	 } 
 } 
 
 f u n c t i o n   p r o c e s s N o t e s I n F o l d e r ( i t e m )   { 
 	 / /   c o n s o l e . l o g ( J S O N . s t r i n g i f y ( i t e m . n o t e s ,   r e p l a c e r ,   "     " ) ) 
 	 c u r r e n t A p p . d o S h e l l S c r i p t ( ` e c h o   ' P r o c e s s i n g   f o l d e r . n a m e = $ { s a n i t i s e V a l u e ( i t e m . n a m e ) } '   > >   ' $ { g l o b a l s . l o g f i l e } ' ` ) 
 	 	 
 	 / /   C r e a t e   d e s t i n a t i o n   f o l d e r   i f   m i s s i n g 
 	 c u r r e n t A p p . d o S h e l l S c r i p t ( ` m k d i r   - p   ' $ { i t e m . p a t h } ' ` ) 
 
 	 / /   S a v e   t h e   n o t e s ,   i n   v a r i o u s   f o r m s 
 	 / / c o n s o l e . l o g ( J S O N . s t r i n g i f y ( i t e m . n o t e s ,   r e p l a c e r ,   "     " ) ) 
 	 l e t   e x p o r t e d   =   0 
 	 l e t   e r r o r s   =   0 
 	 f o r   ( c o n s t   n o t e   o f   i t e m . n o t e s )   { 
 	 	 t r y   { 
 	 	 	 p r o c e s s N o t e ( i t e m ,   n o t e ) 
 	 	 	 e x p o r t e d   =   e x p o r t e d   +   1 
 	 	 	 g l o b a l s . e x p o r t e d C o u n t   =   g l o b a l s . e x p o r t e d C o u n t   +   1 
 	 	 }   c a t c h ( e )   { 
 	 	 	 e r r o r s   =   e r r o r s   +   1 
 	 	 	 g l o b a l s . e r r o r C o u n t   =   g l o b a l s . e r r o r C o u n t   +   1 
 	 	 	 c u r r e n t A p p . d o S h e l l S c r i p t ( ` e c h o   ' E r r o r   p r o c e s s i n g   n o t e   $ { n o t e . i d }   $ { s a n i t i s e V a l u e ( e . m e s s a g e ) } '   > >   ' $ { g l o b a l s . l o g f i l e } ' ` ) 	 	 	 
 	 	 } 
 	 } 
 	 c u r r e n t A p p . d o S h e l l S c r i p t ( ` e c h o   ' P r o c e s s e d   f o l d e r   c o u n t = $ { e x p o r t e d }   e r r o r s = $ { e r r o r s } '   > >   ' $ { g l o b a l s . l o g f i l e } ' ` ) 
 } 
 
 f u n c t i o n   p r o c e s s N o t e ( i t e m ,   n o t e )   { 
 	 / / c o n s o l e . l o g ( J S O N . s t r i n g i f y ( n o t e ,   r e p l a c e r ,   "     " ) ) 
 	 c o n s t   s a f e N a m e   =   s a n i t i s e P a t h ( n o t e . n a m e ) 
 	 c o n s t   s a f e V a l u e   =   s a n i t i s e V a l u e ( n o t e . n a m e ) 
 	 c o n s t   m e t a F i l e   =   i t e m . p a t h     +   ' / '   +   s a f e N a m e   +   ' . i n f o . t x t ' 
 
 	 c o n s o l e . l o g ( s a f e V a l u e ) 
 	 c u r r e n t A p p . d o S h e l l S c r i p t ( ` e c h o   ' E x p o r t i n g   n o t e   i d = $ { n o t e . i d }   n a m e = $ { s a f e V a l u e } '   > >   ' $ { g l o b a l s . l o g f i l e } ' ` ) 
 
 	 P r o g r e s s . a d d i t i o n a l D e s c r i p t i o n   =   ` E x p o r t i n g   $ { n o t e . n a m e } & ` 
 
 	 c o n s t   c r e a t e d   =   n o t e . a o N o t e . c r e a t i o n D a t e ( ) 
 	 c o n s t   u p d a t e d   =   n o t e . a o N o t e . m o d i f i c a t i o n D a t e ( ) 
 	 c o n s t   a t t a c h m e n t s   =   n o t e . a o N o t e . a t t a c h m e n t s 
 	 c o n s t   n u m A t t a c h m e n t s   =   a t t a c h m e n t s . l e n g t h 
 	 c o n s t   e n c r y p t e d   =   n o t e . a o N o t e . p a s s w o r d P r o t e c t e d ( ) 
 	 c u r r e n t A p p . d o S h e l l S c r i p t ( ` e c h o   ' i d = $ { n o t e . i d } '   >   ' $ { m e t a F i l e } ' ` ) 
 	 c u r r e n t A p p . d o S h e l l S c r i p t ( ` e c h o   ' p a r e n t = $ { n o t e . p a r e n t . i d } '   > >   ' $ { m e t a F i l e } ' ` ) 
 	 c u r r e n t A p p . d o S h e l l S c r i p t ( ` e c h o   ' n a m e = $ { s a f e V a l u e } '   > >   ' $ { m e t a F i l e } ' ` ) 
 	 c u r r e n t A p p . d o S h e l l S c r i p t ( ` e c h o   ' c r e a t e d = $ { c r e a t e d } '   > >   ' $ { m e t a F i l e } ' ` ) 
 	 c u r r e n t A p p . d o S h e l l S c r i p t ( ` e c h o   ' u p d a t e d = $ { u p d a t e d } '   > >   ' $ { m e t a F i l e } ' ` ) 
 	 c u r r e n t A p p . d o S h e l l S c r i p t ( ` e c h o   ' e n c r y p t e d = $ { e n c r y p t e d } '   > >   ' $ { m e t a F i l e } ' ` ) 
 	 c u r r e n t A p p . d o S h e l l S c r i p t ( ` e c h o   ' a t t a c h m e n t s = $ { n u m A t t a c h m e n t s } '   > >   ' $ { m e t a F i l e } ' ` ) 
 	 / /   T O D O   -   h a n d l e   U T F 8   p r o p e r l y ?   h t t p s : / / b r u 6 . d e / j x a / a u t o m a t i n g - a p p l i c a t i o n s / n o t e s / 
 	 c o n s t   d a t a F i l e   =   ` $ { i t e m . p a t h } / $ { s a f e N a m e } . h t m l ` 
 	 d u m p T o F i l e ( n o t e . a o N o t e . b o d y ( ) ,   d a t a F i l e ) 
 
 	 c o n s t   t e x t F i l e   =   ` $ { i t e m . p a t h } / $ { s a f e N a m e } . t x t ` 
 	 d u m p T o F i l e ( n o t e . a o N o t e . p l a i n t e x t ( ) ,   t e x t F i l e ) 
 	 f o r   ( l e t   v   =   0 ;   v   <   n u m A t t a c h m e n t s ;   v + + )   { 
 	 	 c o n s t   a t t   =   a t t a c h m e n t s [ v ] 
 	 	 c o n s t   a t t a c h m e n t I d   =   a t t . i d ( ) 
 	 	 c u r r e n t A p p . d o S h e l l S c r i p t ( ` e c h o   ' a t t a c h m e n t . $ { v } . i d = $ { a t t a c h m e n t I d } '   > >   ' $ { m e t a F i l e } ' ` ) 
 	 	 c o n s t   a t t a c h m e n t N a m e   =   a t t . n a m e ( ) 
 	 	 c o n s t   c o n t e n t I d e n t i f i e r   =   a t t . c o n t e n t I d e n t i f i e r ( ) 
 	 	 c o n s t   u r l   =   a t t . u r l ( ) 
 	 	 / /   C o n v e r t   t o   U R L   s o   w e   c a n   g e t   a   n a m e - i d 
 	 	 / /   x - c o r e d a t a : / / 1 8 1 F 2 7 4 4 - C 1 7 D - 4 1 B 1 - B 6 6 D - A A 7 2 5 6 0 F F 0 A 2 / I C A t t a c h m e n t / p 1 4 8 5 
 	 	 c o n s t   a t t a c h m e n t C o r e P i d   =   a t t a c h m e n t I d . s p l i t ( ' / ' ) . r e v e r s e ( ) [ 0 ] ; 
 	 	 c u r r e n t A p p . d o S h e l l S c r i p t ( ` e c h o   ' a t t a c h m e n t . $ { v } . p i d = $ { a t t a c h m e n t C o r e P i d } '   > >   ' $ { m e t a F i l e } ' ` ) 	 	 	 
 	 	 c u r r e n t A p p . d o S h e l l S c r i p t ( ` e c h o   ' a t t a c h m e n t . $ { v } . c i d = $ { c o n t e n t I d e n t i f i e r } '   > >   ' $ { m e t a F i l e } ' ` ) 
 	 	 c u r r e n t A p p . d o S h e l l S c r i p t ( ` e c h o   ' a t t a c h m e n t . $ { v } . u r l = $ { u r l } '   > >   ' $ { m e t a F i l e } ' ` ) 
 	 	 c u r r e n t A p p . d o S h e l l S c r i p t ( ` e c h o   ' a t t a c h m e n t . $ { v } . n a m e = $ { a t t a c h m e n t N a m e } '   > >   ' $ { m e t a F i l e } ' ` ) 
 
 	 	 t r y H a r d A n d S a v e A t t a c h m e n t ( i t e m . p a t h ,   ` $ { s a f e N a m e } . $ { a t t a c h m e n t C o r e P i d } ` ,   a t t a c h m e n t N a m e ,   a t t ,   v ,   m e t a F i l e ,   c o n t e n t I d e n t i f i e r ) 
 	 } 
 } 
 
 / /   I f   t h e   a t t a c h m e n t   i s   n a m e d ,   a n d   h a s   n o   e x t e n s i o n ,   a t t e m p t   t o   s a v e   i t   a s   a   h e i c 
 / /   T h i s   f u n c t i o n   i s   i n t e n d e d   t o   u s e   a   d i f f e r e n t   f i l e n a m e   ( a k a   n o t e n a m e . a t t a c h m e n t p i d n u m b e r . e x t   i n s t e a d   o f   a t t a c h m e n t n a m e . e x t ) 
 / /   S o m e   i m a g e s   /   c a p t u r e s   s e e m   t o   b e   l i k e   t h i s 
 / /   I f   t h a t   f a i l e d ,   t r y   a g a i n   a s   a   P N G 
 / /   I f   t h a t   f a i l e d ,   t r y   a g a i n   a s   a   P D F   e t c .   C o u l d   b e   a u d i o   a s   w e l l ,   n e e d   t o   t e s t 
 / /   A l s o   t h e   p r o b l e m   o f   a n   ' e x t e n s i o n '   t h a t   i s   n o t ,   i . e .   o n e   w i t h   a   d o t   i n   a n   u n k n o w n   e x t e n s i o n   t y p e   n a m e 
 f u n c t i o n   t r y H a r d A n d S a v e A t t a c h m e n t ( p a t h ,   b a s e n a m e ,   a t t a c h m e n t N a m e ,   a t t ,   v ,   m e t a F i l e ,   c i d )   { 
 	 c o n s t   a t t a c h m e n t E x t   =   s a n i t i s e P a t h ( g e t E x t ( a t t a c h m e n t N a m e ) ) 
 	 i f   ( G o o d A t t a c h m e n t s . i n c l u d e s ( a t t a c h m e n t E x t   | |   ' ' ) )   { 
 	 	 c o n s t   a t t a c h m e n t F i l e   =   ` $ { b a s e n a m e } . $ { a t t a c h m e n t E x t } ` 
 	 	 c u r r e n t A p p . d o S h e l l S c r i p t ( ` e c h o   ' a t t a c h m e n t . $ { v } . f i l e = $ { s a n i t i s e V a l u e ( a t t a c h m e n t F i l e ) } '   > >   ' $ { m e t a F i l e } ' ` ) 
 	 	 / /   T O D O :   c o n v e r t   H E I C   t o   J P E G   a s   w e l l 
 	 	 c o n s t   a t t a c h m e n t F i l e n a m e   =   ` $ { p a t h } / $ { a t t a c h m e n t F i l e } ` 
 	 	 t r y   { 
 	 	 	 N o t e s . s a v e ( a t t ,   { i n :   P a t h ( a t t a c h m e n t F i l e n a m e ) } ) 
 	 	 	 r e t u r n 
 	 	 }   c a t c h   ( e )   { 
 	 	 	 c u r r e n t A p p . d o S h e l l S c r i p t ( ` e c h o   ' E r r o r   ( 1 )   a t t e m p t i n g   t o   s a v e   a t t a c h m e n t   { $ { s a n i t i s e V a l u e ( a t t a c h m e n t N a m e ) } } :   $ { s a n i t i s e V a l u e ( e . m e s s a g e ) } '   > >   ' $ { g l o b a l s . l o g f i l e } ' ` ) 	 	 	 
 	 	 } 	 
 	 } 
 	 c u r r e n t A p p . d o S h e l l S c r i p t ( ` e c h o   ' E r r o r i n g   /   u n u s u a l   a t t a c h m e n t   c i d = $ { c i d } '   > >   ' $ { g l o b a l s . l o g f i l e } ' ` ) 
 	 / /   t r y   a s   n a t i v e   f o r m a t : 
 	 i f   ( t r u e )   { 
 	 	 c o n s t   a t t a c h m e n t F i l e   =   ` $ { b a s e n a m e } - n a t i v e ` 
 	 	 c u r r e n t A p p . d o S h e l l S c r i p t ( ` e c h o   ' a t t a c h m e n t . $ { v } . f i l e . a t t e m p t = $ { a t t a c h m e n t F i l e } '   > >   ' $ { m e t a F i l e } ' ` ) 
 	 	 c o n s t   a t t a c h m e n t F i l e n a m e   =   ` $ { p a t h } / $ { a t t a c h m e n t F i l e } ` 
 	 	 t r y   { 
 	 	 	 N o t e s . s a v e ( a t t ,   { i n :   P a t h ( a t t a c h m e n t F i l e n a m e ) ,   a s :   ' n a t i v e   f o r m a t ' } ) 
 	 	 	 r e t u r n 
 	 	 }   c a t c h   ( e )   { 
 	 	 	 c u r r e n t A p p . d o S h e l l S c r i p t ( ` e c h o   ' E r r o r   ( 2 )   a t t e m p t i n g   t o   s a v e   a t t a c h m e n t   { $ { s a n i t i s e V a l u e ( a t t a c h m e n t N a m e ) } } :   $ { s a n i t i s e V a l u e ( e . m e s s a g e ) } '   > >   ' $ { g l o b a l s . l o g f i l e } ' ` ) 	 	 	 
 	 	 } 
 	 } 
 	 
 	 / / N o t e s . s h o w ( a t t ,   { s e p a r a t e l y :   t r u e } ) 
 	 
 	 / /   O K ,   j u s t   t r y   a   b u n c h   o f   k n o w n   e x t e n s i o n s   u n t i l   w e   f i n d   o n e 
 	 l e t   w o r k e d   =   f a l s e 
 	 f o r   ( c o n s t   e x t   o f   G o o d A t t a c h m e n t s )   { 
 	 	 c o n s t   a t t a c h m e n t F i l e   =   ` $ { b a s e n a m e } . $ { e x t } ` 
 	 	 c u r r e n t A p p . d o S h e l l S c r i p t ( ` e c h o   ' a t t a c h m e n t . $ { v } . f i l e . a t t e m p t = $ { a t t a c h m e n t F i l e } '   > >   ' $ { m e t a F i l e } ' ` ) 
 	 	 c o n s t   a t t a c h m e n t F i l e n a m e   =   ` $ { p a t h } / $ { a t t a c h m e n t F i l e } ` 
 	 	 t r y   { 
 	 	 	 N o t e s . s a v e ( a t t ,   { i n :   P a t h ( a t t a c h m e n t F i l e n a m e ) ,   a s :   ' n a t i v e   f o r m a t ' } ) 
 	 	 	 w o r k e d   =   t r u e 
 	 	 	 b r e a k   / /   w e   m u s t   h a v e   s u c c e e d e d 
 	 	 }   c a t c h ( e )   { 
 	 	 	 c u r r e n t A p p . d o S h e l l S c r i p t ( ` e c h o   ' E r r o r   a t t e m p t i n g   t o   s a v e   a t t a c h m e n t   { $ { s a n i t i s e V a l u e ( a t t a c h m e n t N a m e ) } } :   $ { s a n i t i s e V a l u e ( e . m e s s a g e ) } '   > >   ' $ { g l o b a l s . l o g f i l e } ' ` ) 	 	 	 
 	 	 } 
 	 } 
 	 i f   ( ! w o r k e d )   { 
 	         t h r o w   n e w   E r r o r ( " U n a b l e   t o   s a v e   a t t a c h m e n t " )   / /   e n s u r e   c o u n t e r 
 	 } 
 } 
 
 f u n c t i o n   g e t E x t ( f i l e N a m e )   { 
 	 i f   ( ! f i l e N a m e )   r e t u r n   n u l l 
 	 c o n s t   r   =   f i l e N a m e . s p l i t ( ' . ' ) 
 	 i f   ( r . l e n g t h   <   2 )   r e t u r n   " " 
 	 r e t u r n   r . r e v e r s e ( ) [ 0 ] 	 
 } 
 
 f u n c t i o n   d u m p T o F i l e ( t e x t ,   f i l e N a m e )   { 
 	 c o n s t   f   =   c u r r e n t A p p . o p e n F o r A c c e s s ( P a t h ( f i l e N a m e ) ,   {   w r i t e P e r m i s s i o n :   t r u e   } ) 
         c u r r e n t A p p . s e t E o f ( f ,   {   t o :   0   } ) 
 	 c u r r e n t A p p . w r i t e ( t e x t ,   {   t o :   f ,   s t a r t i n g A t :   c u r r e n t A p p . g e t E o f ( f )   } ) 
 	 c u r r e n t A p p . c l o s e A c c e s s ( f ) 
 } 
 
 / /   H e l p e r   f u n c t i o n   t o   e s c a p e   t h i n g s   t h a t   w i l l   g o   i n   s h e l l   s i n g l e   q u o t e   s t r i n g s ,   t h a t   a r e   n o t   f i l e n a m e s 
 f u n c t i o n   s a n i t i s e V a l u e ( s )   { 
 	 c o n s t   r e s u l t   =   ! ! s   ?   s 
 	 	 . r e p l a c e ( / ' / g ,   " ' \ " ' \ " ' " ) 
 	 	 . r e p l a c e ( / \ ( / g ,   " ' \ " ( \ " ' " )   :   s 
 
 	 r e t u r n   r e s u l t   / /   r e m e m b e r ,   r e t u r n   d o t   l i n e s   c a n t   b r e a k . . . 
 } 
 
 / /   H e l p e r   f u n c t i o n   t o   s t r i p   o u t   s l a s h e s   a n d   s u c h   a n d   r e p l a c e   t h e m   w i t h   u n d e r s c o r e s ,   e t c . 
 f u n c t i o n   s a n i t i s e P a t h ( s )   { 
 	 / / c o n s o l e . l o g ( ` s a n i t i s e P a t h   s = $ { s } ` ) 
 	 c o n s t   r e s u l t   =   ! ! s   ?   s 
 	 	 . r e p l a c e ( / ' / g ,   " _ " ) 
 	 	 . r e p l a c e ( / \ * / g ,   " _ " ) 
 	 	 . r e p l a c e ( / \ ? / g ,   " _ " ) 
 	 	 . r e p l a c e ( / \ " / g ,   " _ " ) 
 	 	 . r e p l a c e ( / \ \ / g ,   " _ " ) 
 	 	 . r e p l a c e ( / \ / / g ,   " _ " )   :   s 
 
 	 r e t u r n   r e s u l t   / /   r e m e m b e r ,   r e t u r n   d o t   l i n e s   c a n t   b r e a k . . . 
 
 	 / /   T h i s   w i l l   e s c a p e   a   q u o t e   t o   _ k e e p _   i t ,   s e e   h t t p s : / / s t a c k o v e r f l o w . c o m / a / 4 8 2 7 4 1 8 1 / 2 7 7 2 4 6 5 
 	 / / 	 . r e p l a c e ( " ' " ,   " ' \ " ' \ " ' " ,   " g " ) 
 } 
 
 / /   H e l p e r   f u n c t i o n   t o   r e c u r s i v e l y   p r o c e s s   a   t r e e   s t r u c t u r e 
 / /   T h e   t r e e   i s   a n   A r r a y - l i k e   o b j e c t ,   w h e r e   e a c h   e l e m e n t   m a y   o r   m a y   n o t   h a v e   a   c h i l d r e n   p r o p e r t y 
 / /   T h e   p r o p e r t y   c h i l d r e n   i s   i t s e l f   a n   A r r a y - l i k e   o b j e c t   o f   e l e m e n t s   t h a t   m a y   o r   m a y   n o t   h a v e   a   c h i l d r e n   p r o p e r t y ,   e t c . 
 / /   T h e   v a l u e   o f   l e v e l   s h o u l d   b e   0   f r o m   t h e   c a l l e r ,   i t   i s   i n c r e m e n t e d   o n   e a c h   r e c u r s i o n 
 / /   f n ( )   i s   a   f u n c t i o n   t o   c a l l   f o r   e v e r y   i t e m 
 / /   I f   d e s c e n d F i r s t   i s   t r u t h y ,   w i l l   p r o c e s s   t h e   i t e m s   o f   t h e   i t e m s   c h i l d r e n   p r o p e r t y   b e f o r e   c a l l i n g   f n ( )   f o r   e a c h   i t e m 
 / /   I f   d e s c e n d F i r s t   i s   f a l s y ,   w i l l   p r o c e s s   t h e   i t e m s   o f   t h e   i t e m s   c h i l d r e n   p r o p e r t y   a f t e r   c a l l i n g   f n ( )   f o r   e a c h   i t e m 
 f u n c t i o n   r e c u r s e I t e m s ( t r e e ,   l e v e l ,   f n ,   d e s c e n d F i r s t )   { 
 	 f o r   ( c o n s t   i t e m   o f   t r e e )   { 
 	 	 h a s C h i l d r e n   =   i t e m . h a s O w n P r o p e r t y ( ' c h i l d r e n ' ) 
 	 	 i f   ( ! ! d e s c e n d F i r s t   & &   h a s C h i l d r e n )   { 
 	 	 	 r e c u r s e I t e m s ( i t e m . c h i l d r e n ,   l e v e l + 1 ,   f n ,   d e s c e n d F i r s t ) 
 	 	 } 
 	 	 f n ( i t e m ,   l e v e l ) 
 	 	 i f   ( ! d e s c e n d F i r s t   & &   h a s C h i l d r e n )   { 
 	 	 	 r e c u r s e I t e m s ( i t e m . c h i l d r e n ,   l e v e l + 1 ,   f n ,   d e s c e n d F i r s t ) 
 	 	 } 
 	 } 
 } 
 
 / /   H e l p e r   f u n c t i o n   t o   c r e a t e   a   t r e e   o b j e c t   f r o m   a   f l a t   l i s t   w i t h   a   l e n g t h   p r o p e r t y 
 / /   f n ( )   i s   c a l l e d   f o r   e a c h   i t e m   i n   t h e   l i s t   a n d   r e t u r n s   a   c h i l d   n o d e   t o   b e   a d d e d   t o   t h e   t r e e 
 / /   e a c h   c h i l d   n o d e   s h o u l d   h a v e   a n   i d   p r o p e r t y   a d d e d   b y   f n ( ) 
 / /   e a c h   c h i l d   n o d e   s h o u l d   h a v e   a   p a r e n t I d   p r o p e r t y   a d d e d   b y   f n ( ) ,   i f   m i s s i n g   i s   i n t e r p r e t e d   a s   n u l l   a n d   t h u s   a t   t h e   r o o t 
 / /   i f   t h e   p a r e n t I d   a l t e r n a t e l y   i s   s a m e   a s   r o o t I d   a n d   r o o t I d   i s   n o t   n u l l   t h e n   t h i s   i s   a l s o   t r e a t e d   a s   a   r o o t   e l e m e n t 
 / /   T h i s   r o u t i n e   t h e n   a d d s   a   c h i l d r e n [ ]   p r o p e r t y   t o   t h e   e l e m e n t   a n d   r e a r r a n g e s   i n t o   a   t r e e   b a s e d   o n   p a r e n t I d 
 / /   T h e   t r e e   i s   a n   A r r a y - l i k e   o b j e c t ,   w h e r e   e a c h   e l e m e n t   m a y   o r   m a y   n o t   h a v e   a   c h i l d r e n   p r o p e r t y 
 / /   T h e   p r o p e r t y   c h i l d r e n   i s   i t s e l f   a n   A r r a y - l i k e   o b j e c t   o f   e l e m e n t s   t h a t   m a y   o r   m a y   n o t   h a v e   a   c h i l d r e n   p r o p e r t y ,   e t c . 
 / /   R e t u r n s   t h e   g e n e r a t e d   t r e e 
 / /   I n s p i r e d   b y : 
 / /   h t t p s : / / m e d i u m . c o m / @ l i z h u o h a n g . s e l i n a / b u i l d i n g - a - h i e r a r c h i c a l - t r e e - f r o m - a - f l a t - l i s t - a n - e a s y - t o - u n d e r s t a n d - s o l u t i o n - v i s u a l i s a t i o n - 1 9 c b 2 4 b d f a 3 3 
 f u n c t i o n   b u i l d T r e e ( l i s t ,   f n ,   r o o t I d )   { 
 	 c o n s t   h a s h M a p   =   { } 
 	 c o n s t   n u m I t e m s   =   l i s t . l e n g t h 
 	 f o r   ( l e t   n = 0 ;   n   <   n u m I t e m s ;   n + + )   { 
 	 	 c o n s t   e l e m e n t   =   f n ( l i s t [ n ] ) 
 	 	 i f   ( ! e l e m e n t )   {   c o n t i n u e   }   / /   a l l o w   e a r l y   f i l t e r i n g 
 	 	 c o n s t   i d   =   e l e m e n t . i d 
 	 	 e l e m e n t . c h i l d r e n   =   [ ] 
 	 	 i f   ( ! h a s h M a p . h a s O w n P r o p e r t y ( i d ) )   { 
 	 	 	 h a s h M a p [ i d ]   =   e l e m e n t 
 	 	 }   e l s e   { 
 	 	 	 t h r o w   ' S h o u l d   n o t   h a p p e n   ( d u p l i c a t e   e l e m e n t   i d   d e t e c t e d ) ' 
 	 	 } 
 	 } 
 	 / /   c o n s o l e . l o g ( J S O N . s t r i n g i f y ( h a s h M a p ,   n u l l ,   "     " ) ) 
 	 c o n s t   i d s   =   O b j e c t . g e t O w n P r o p e r t y N a m e s ( h a s h M a p ) 
 	 c o n s t   t r e e   =   [ ] 
 	 f o r   ( c o n s t   k   o f   i d s )   { 
 	 	 i f   ( h a s h M a p . h a s O w n P r o p e r t y ( k ) )   { 
 	 	 	 c o n s t   m   =   h a s h M a p [ k ] 
 	 	 	 c o n s t   p a r e n t I d   =   m . p a r e n t I d   | |   n u l l 
 	 	 	 i f   ( ! p a r e n t I d   | |   ( ! ! r o o t I d   & &   p a r e n t I d   = = =   r o o t I d ) )   { 
 	 	 	 	 / /   T h i s   i t e m   i s   i n   t h e   r o o t   f o l d e r 
 	 	 	 	 / /   W e   c o u l d   o p t i o n a l l y   s t r i p   t h e   p a r e n t I d   e n t i r e l y ,   t o   s a v e   s p a c e . . . 
 	 	 	 	 / /   m . p a r e n t I d   =   n u l l 
 	 	 	 	 m . p a r e n t   =   n u l l 
 	 	 	 	 t r e e . p u s h ( m ) 
 	 	 	 }   e l s e   { 
 	 	 	 	 m . p a r e n t   =   h a s h M a p [ p a r e n t I d ] 
 	 	 	 	 h a s h M a p [ p a r e n t I d ] . c h i l d r e n . p u s h ( m ) 
 	 	 	 } 
 	 	 } 
 	 } 
 	 / /   c o n s o l e . l o g ( J S O N . s t r i n g i f y ( t r e e ,   [ ' i d ' ,   ' p a r e n t I d ' ,   ' c h i l d r e n ' ] ,   "     " ) ) 
 	 r e t u r n   t r e e 
 } 
 
 / /   E n u m e r a t e   o v e r   a l l   f o l d e r s   i n   a n   a c c o u n t 
 / /   C r e a t e   a   t r e e   o f   t h e   f o l d e r s ,   a n d   a d d   a   f i l e s y s t e m - l i k e   p a t h   t o   e a c h 
 / /   t h a t   w e   c a n   n e x t   u s e   t o   e x p o r t   n o t e s   t o   d i s k   i n   t h e   s a m e   s t r u c t u r e 
 / /   R e t u r n   t h e   t r e e 
 f u n c t i o n   e n u m e r a t e F o l d e r s ( a c c o u n t )   { 
 	 c o n s t   a c c o u n t I d   =   a c c o u n t . i d ( ) 
 	 c o n s t   t r e e   =   b u i l d T r e e ( a c c o u n t . f o l d e r s ,   ( f o l d e r )   = >   { 
 	 	 c o n s t   f o l d e r I d   =   f o l d e r . i d ( ) 
 	 	 c o n s t   f o l d e r N a m e   =   f o l d e r . n a m e ( ) 
 	 	 c o n s t   p a r e n t   =   f o l d e r . c o n t a i n e r 
 	 	 c o n s t   p a r e n t I d   =   p a r e n t . i d ( ) 
 	 	 i f   ( f o l d e r N a m e   = = =   ' R e c e n t l y   D e l e t e d ' )   { 
 	 	 	 r e t u r n   n u l l 
 	 	 } 
 	 	 P r o g r e s s . a d d i t i o n a l D e s c r i p t i o n   =   ` I n s p e c t i n g   $ { f o l d e r N a m e } & ` 
 	 	 r e t u r n   { 
 	 	 	 i d :   f o l d e r I d , 
 	 	 	 p a r e n t I d :   p a r e n t I d , 	 	 	 
 	 	 	 n a m e :   f o l d e r N a m e , 
 	 	 	 a o F o l d e r :   f o l d e r 
 	 	 } 
 	 } ,   a c c o u n t I d ) 
 	 / /   c o n s o l e . l o g ( J S O N . s t r i n g i f y ( t r e e ,   [ ' n a m e ' ,   ' p a r e n t I d ' ,   ' c h i l d r e n ' ,   ' i d ' ] ,   "     " ) ) 
 	 
 	 c o n s t   p a t h P r e f i x   =   g l o b a l s . o u t p u t F o l d e r . t o S t r i n g ( )   +   ' / '   +   s a n i t i s e P a t h ( a c c o u n t . n a m e ( ) ) 
 	 c o n s o l e . l o g ( ` p a t h P r e f i x = $ { p a t h P r e f i x   } ` ) 
 
 	 r e c u r s e I t e m s ( t r e e ,   0 ,   ( i t e m ,   l e v e l )   = >   { 
 	 	 / /   c o n s o l e . l o g ( ` R e c u r s e F u n c t i o n :   $ { l e v e l }   - - >   $ { i t e m . n a m e } ` ) 
 	 	 i f   ( l e v e l   >   0 )   { 
 	 	 	 / /   f o r   t h i s   t o   w o r k   w e   n e e d   t o   d e s c e n d   a f t e r ,   s o   t h e   p a r e n t s   p a t h   i s   s e t 
 	 	 	 i t e m [ ' p a t h ' ]   =   i t e m . p a r e n t . p a t h   +   ' / '   +   s a n i t i s e P a t h ( i t e m . n a m e ) 
 	 	 }   e l s e   { 
 	 	 	 i t e m [ ' p a t h ' ]   =   p a t h P r e f i x   +   ' / '   +   s a n i t i s e P a t h ( i t e m . n a m e ) 
 	 	 } 
 	 } ,   f a l s e ) ; 
 	 / / c o n s o l e . l o g ( J S O N . s t r i n g i f y ( t r e e ,   [ ' n a m e ' ,   ' i d ' ,   ' p a r e n t I d ' ,   ' p a t h ' ,   ' c h i l d r e n ' ] ,   "     " ) ) 
 	 r e t u r n   t r e e ; 
 } 
 
 / /   V i s i t   e a c h   f o l d e r   i n   t r e e   s t r u c t u r e   a n d   g a t h e r   n o t e s   a s   a n   A r r a y   o n   e a c h   t r e e   i t e m 
 / /   T O D O   c h e c k   f o r   d u p l i c a t e s ,   s o   w e   c a n   c h a n g e   t h e   n a m e   t o   s u i t 
 f u n c t i o n   e n u m e r a t e N o t e s ( t r e e )   { 	 
 	 c o n s t   N o t e s   =   A p p l i c a t i o n ( ' N o t e s ' ) 
 	 c o n s t   n a m e I n d e x   =   { } 
 	 r e c u r s e I t e m s ( t r e e ,   0 ,   ( i t e m ,   l e v e l )   = >   { 
 	 	 c o n s t   m y N o t e s   =   [ ] 
 	 	 c o n s t   t h e N o t e s   =   i t e m . a o F o l d e r . n o t e s 
 	 	 c o n s t   n u m N o t e s   =   t h e N o t e s . l e n g t h 
 	 	 f o r   ( l e t   n = 0 ;   n   <   n u m N o t e s ;   n + + )   { 
 	 	 	 c o n s t   n o t e   =   t h e N o t e s [ n ] 
 	 	 	 c o n s t   n o t e I d   =   n o t e . i d ( ) 
 	 	 	 c o n s t   n o t e N a m e   =   n o t e . n a m e ( ) 
 	 	 	 c o n s t   s a f e V a l u e   =   s a n i t i s e V a l u e ( n o t e N a m e ) 
 	 	 	 c o n s o l e . l o g ( s a f e V a l u e ) 
 	 	 	 / /   E n s u r e   n o   n a m e s   a r e   d u p l i c a t e d 
 	 	 	 l e t   n o t e N a m e N e x t   =   " "   +   n o t e N a m e 
 	 	 	 l e t   x   =   1 
 	 	 	 w h i l e   ( n a m e I n d e x . h a s O w n P r o p e r t y ( n o t e N a m e N e x t ) )   { 
 	 	 	 	 n o t e N a m e N e x t   =   n o t e N a m e   +   `   $ { x } ` 
 	 	 	 	 x   =   x   +   1 
 	 	 	 } 
 	 	 	 P r o g r e s s . a d d i t i o n a l D e s c r i p t i o n   =   ` I n s p e c t i n g   $ { n o t e N a m e } & ` 
 
 	 	 	 m y N o t e s . p u s h ( { 
 	 	 	 	 i d :   n o t e I d , 
 	 	 	 	 n a m e :   n o t e N a m e N e x t , 
 	 	 	 	 a o N o t e :   n o t e , 
 	 	 	 	 p a r e n t :   i t e m 
 	 	 	 	 
 	 	 	 } ) 
 	 	 	 n a m e I n d e x [ n o t e N a m e N e x t ]   =   t r u e 
 	 	 } 
 	 	 i t e m . n o t e s   =   m y N o t e s 
 	 } ,   t r u e ) ; 
 } 
                              x6jscr  ��ޭ