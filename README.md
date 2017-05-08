# AHPinterest

### Purpose
This project copies Pinterest's Home and Discover modules, without any third-party library just for the purpose of practicing my iOS fundamentals. 

I use a random data generator for random size pictures because I want more controls of the data and simplicity.

In this article, all “layouts” are referred to UICollectionViewLayout or its subclass, NOT AutoLayout! 

### Demo
The link below is a 2-minute demo of the project. The video was recorded in MOV format but when I uploaded to Youtube. Its video quality was significantly damaged. I'll learn the whole web development soon.The app is actually quite smooth. You can download the zip file and do a build-and-run if you wanna feel about it.

[Demo](https://youtu.be/CXQuMl_qBdI) (2 minutes)
### Further Optimization
I found there’s a little bit frame dropped when first load a AHDetailVC(after selecting a pin cell) then immediately scroll. 

1. A more sophisticated networking tool and an image rendering method are needed. I saw some developers literally draw their cell's content on a graphics image context asynchronously in order to reduce layers in the cell and loading speed, which is awesome. 

2. Pinterest uses Texture(or AsyncDisplayKit) to render graphics.  I will dig into this monster framework later.

3. Make all methods and properties have more specific access control in order to get the most out of the Whole Module Optimization under Swift

4. Use Realm or Firebase for Discover search feature which I didn't implement. But I think I did a good job demonstrating Pinterest's most beautiful designs and I should stop from here.

### Final Words
I give myself a B+ for this project because it doesn’t support media which could a bit trickier for performance and I cheated a little bit by caching the same sizes' images (I didn’t wanna get throttled by placeholder sites) -- this makes the networking less busy. And in real app, most images are different and have to be downloaded first. 

And I like my layout router idea — one collectionView has multiple different layouts. Each custom layout has its own section. And in each section, regular cell attributes, supplement attributes as well as decoration attributes are all relative to their own section. You can always start layout attributes from point(0,0) and the layoutRouter will normalized all those attributes later. This means each custom layout is relatively independent and plugabble. 

If you have a more simple solution than this router one, let me know. I’ll buy you a lunch ;)

### Some Important Class Descriptions
#### 1. Most important components for the Home view controller(AHPinVC):

AHCollectionVC: A UICollectionViewController with a layout router and some associated methods to make multiple layouts in the same collectionView possible.

AHPinVC: A subclass of AHCollectionVC and it handles cell selections and data loadings. It’s added with features like header/footer refresh controls, water fall layout, option popup animation when long press a cell.  All those features are all modular. You can turn them on and off. And when a cell is selected, this VC pushes a AHDetailVC into the navigation stack.
 
AHDetailVC: A page view controller acting as a detail pin gallery, written with a collectionView attached a flowLayout. This VC has only AHPageCell — a placeholder cell for other VCs.

AHPinContentVC: A subclass of AHPinVC. It lives within a AHPageCell. It’s added a AHPinContentLayout before the inherited water fall layout, to show the large image of the pin cell which was selected then pushed from AHPinVC. The VC also has a drag-to-dismiss transition animation along with the long press popup animation.

#### 2. Most important components for the Discover view controller:
AHDiscoverVC: It’s also a page VC written in collectionView like AHDetailVC. And it has a category navBar and a AHDiscoverCategoryVC.
AHDiscoverCategoryVC: A subclass of AHPinVC, added a flowLayout-liked layout before the water fall layout.








