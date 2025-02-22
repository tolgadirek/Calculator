import 'package:flutter/material.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  String butunIslemler = "0";
  String gorunenSayi = "0";
  double sonuc = 0;
  String sonIslem = "";
  List<String> islemList = [];
  bool virgulDurum = false;
  bool negatifDurum = false;

  Widget rakamButon(String sayi, int butonGenislik, Color renk, double ekranYuksekligi) {
    return Expanded(
        flex: butonGenislik,
        child: Container( //container koymamızın sebebi yükseklik koymak ve margin koymak.
          height: ekranYuksekligi/8.84, // Ekran boyutuna göre dinamik bir değer verdik.
          margin: const EdgeInsets.all(3.0), // Butona her taraftan 3birim boşluk ver.
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: renk,),
            onPressed: (){
              setState(() {
                if(sonIslem == "="){ // = bastıktan sonra herhangi bir sayıya basıtığımızda sıfırlansın her şey AC gibi.
                  butunIslemler = "0";
                  sonuc = 0;
                  gorunenSayi = "0";
                  sonIslem = "";
                  islemList.clear();
                }
                String kontrol = butunIslemler.substring(butunIslemler.length-1); //son string değeri aldık.
                if(kontrol == "+" || kontrol == "—" || kontrol == "x" || kontrol == "/" || kontrol == "%"){
                  gorunenSayi = "0"; // Eğer en son basılan tuş işlemse görünensayıyı sıfırlasın ki yeni sayı eklensin.
                }
                if(butunIslemler == "0"){
                  butunIslemler = sayi;
                  gorunenSayi = sayi;
                }else{
                  butunIslemler = "$butunIslemler$sayi";
                  if(gorunenSayi != "0") {
                    gorunenSayi = "$gorunenSayi$sayi";
                  }else{
                    gorunenSayi = sayi;
                  }
                }
              });
            }, child: Text(sayi, style: TextStyle(fontSize: ekranYuksekligi/23.58, color: Colors.white),),),
        )
    );
  }

  Widget islemButon(String islem, int butonGenislik, Color renk, double ekranYuksekligi) {
    return Expanded(
        flex: butonGenislik,
        child: Container( //container koymamızın sebebi yükseklik koymak ve margin koymak.
          height: ekranYuksekligi/8.84,
          margin: const EdgeInsets.all(3.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: renk,),
            onPressed: (){
              setState(() {
                if(sonIslem == "="){ // = bastıktan sonra herhangi bir işleme bastığımızda.
                  butunIslemler = "$gorunenSayi$islem"; // O sonuç üzeriinden işlem yapılsın.
                }else{ // Eğer son işlem = değilse;
                  String kontrol = butunIslemler.substring(butunIslemler.length-1);
                  if(kontrol == "+" || kontrol == "—" || kontrol == "x" || kontrol == "/" || kontrol == "%"){ // Eğer bundan önce en son basılan tuş işlemlerden biriyse;
                    islemList[islemList.length-1] = islem; //son işlemi listede değiştir

                    //Ekranda görünen bütün işlemlerde son işlemi değiştirme
                    List<String> ekranListe = butunIslemler.split('');
                    ekranListe[ekranListe.length-1] = islem;
                    butunIslemler = ekranListe.join('');

                    // İşlem değişirken var olan sonuca o yeni gelen işlem etki etmesin diye herhangi bir tuş için etki koymadık.

                  }else{ // Eğer bundan önce son basılan buton işlem butonu değil de başka bir tuşsa
                    islemList.add(islem); // Listeye bu işlemi ekle
                    butunIslemler = "$butunIslemler${islemList[islemList.length-1]}";
                    if(sonuc == 0){
                      sonuc = double.parse(gorunenSayi); // Eğer ilk sayı giriliyorsa sonuca eşitle.
                    }else { // Eğer ilk girilen sayı değilse;
                      switch (islemList[islemList.length-2]) { // bi önceki basılan işleme göre sonucu belirle. Çünkü son girilen sayıyı bu tuştan önce toplamamız lazım.
                        case "+":
                          sonuc += double.parse(gorunenSayi);
                          break;
                        case "—":
                          sonuc -= double.parse(gorunenSayi);
                          break;
                        case "x":
                          sonuc *= double.parse(gorunenSayi);
                          break;
                        case "/":
                          sonuc /= double.parse(gorunenSayi);
                          break;
                        case "%":
                          sonuc %= double.parse(gorunenSayi);
                          break;
                      }
                    }
                  }
                }
                String kontrolSonuc = "$sonuc".substring("$sonuc".length-2, "$sonuc".length); // Sonucun son iki basamağını al
                if(kontrolSonuc == ".0") { // Eğer sonuçta .0 varsa yani double olmasını gerektirmiyorsa
                  gorunenSayi = "${sonuc.toInt()}"; // int şeklinde göster dedik.
                }else{
                  gorunenSayi = "$sonuc";
                }
                sonIslem = islem;
                virgulDurum = false;
                negatifDurum = false;
              });
            }, child: Text(islem, style: TextStyle(fontSize: ekranYuksekligi/23.58, color: Colors.white),),),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context); // Ekran bilgilerine eriştik.
    final double ekranYuksekligi = ekranBilgisi.size.height; //707.43

    return Scaffold(backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
                alignment: Alignment.centerRight, // Sağa yapıştırdık.
                child: SingleChildScrollView( // Kayma etkinleştirme
                    scrollDirection: Axis.horizontal, // Yatayda boyut aştıkça yana doğru kayma etkinleşsin dedik.
                    reverse: true, //Kayma yönünü tersine çevirdik ki hep en sağ taraf gözüksün. Sola doğru kaysın.
                    child: Text(butunIslemler, style: TextStyle(color: Colors.white30, fontSize: ekranYuksekligi/35.37),)
                )
            ),
            Container(
                alignment: Alignment.centerRight,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(gorunenSayi, style: TextStyle(color: Colors.white, fontSize: ekranYuksekligi/11.79),)
                )
            ),
            Row(
              children: [
                // AC BUTONU
                Expanded(
                    flex: 1,
                    child: Container( //container koymamızın sebebi yükseklik koymak ve margin koymak.
                    height: ekranYuksekligi/8.84,
                    margin: const EdgeInsets.all(3.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white30,),
                      onPressed: (){
                        setState(() { // Her şeyi sıfırladık. En başa döndük.
                          butunIslemler = "0";
                          gorunenSayi = "0";
                          sonuc = 0;
                          sonIslem = "";
                          islemList.clear();
                          virgulDurum = false;
                          negatifDurum = false;
                        });
                      }, child: Text("AC", style: TextStyle(fontSize: ekranYuksekligi/28.3, color: Colors.white),),),
                    )
                ),
                // +/- BUTONU
                Expanded(
                    flex: 1,
                    child: Container( //container koymamızın sebebi yükseklik koymak ve margin koymak.
                      height: ekranYuksekligi/8.84,
                      margin: const EdgeInsets.all(3.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white30,),
                        onPressed: (){
                          setState(() {
                            if(sonIslem == "="){ // = bastıktan sonra basıtığımızda sıfırlansın her şey AC gibi.
                              butunIslemler = "0";
                              sonuc = 0;
                              gorunenSayi = "0";
                              sonIslem = "";
                              islemList.clear();
                            }
                            String kontrol = butunIslemler.substring(butunIslemler.length-1);
                            List<String> varmi = gorunenSayi.split('');
                            negatifDurum = !negatifDurum; // Tıklandığında bool değeri değişsin

                            if(!negatifDurum && varmi.contains("-")){ // Eğer false ve içerde - varsa
                              if(!(varmi.contains("1")||varmi.contains("2")||varmi.contains("3")||varmi.contains("4")||varmi.contains("5")||varmi.contains("6")||varmi.contains("7")||varmi.contains("8")||varmi.contains("9"))){
                                List<String> gorunenSayiKontrol = gorunenSayi.split('');
                                gorunenSayiKontrol.removeAt(0);
                                gorunenSayi = gorunenSayiKontrol.join('');
                                if(gorunenSayi == ""){ // Sildikten sonra boş ekran kalmaması için 0 kalsın dedik.
                                  gorunenSayi = "0";
                                }
                                List<String> butunIslemlerKontrol = butunIslemler.split('');
                                butunIslemlerKontrol.removeLast();
                                butunIslemler = butunIslemlerKontrol.join('');
                                if(butunIslemler == ""){ // Sildikten sonra boş ekran kalmaması için 0 kalsın dedik.
                                  butunIslemler = "0";
                                }
                              }
                            }else if(!(varmi.contains("-")) && negatifDurum){ // Eğer true ve - yoksa
                              if(kontrol == "+" || kontrol == "—" || kontrol == "x" || kontrol == "/" || kontrol == "%"){
                                gorunenSayi = "0";
                              }
                              if(gorunenSayi == "0"){
                                if(butunIslemler == "0"){
                                  butunIslemler = "";
                                }
                                gorunenSayi = "-";
                                butunIslemler = "$butunIslemler-";
                              }
                            }else if(negatifDurum && varmi.contains("-")){ // Eğer true ve - varsa
                              if(kontrol == "+" || kontrol == "—" || kontrol == "x" || kontrol == "/" || kontrol == "%"){
                                gorunenSayi = "-";
                                butunIslemler = "$butunIslemler-";
                              }
                            }
                          });
                        }, child: Text("+/-", style: TextStyle(fontSize: ekranYuksekligi/28.3, color: Colors.white),),),
                    )
                ),
                islemButon("%", 1, Colors.white30, ekranYuksekligi),
                islemButon("/", 1, Colors.orange, ekranYuksekligi),
              ],
            ),
            Row(
              children: [
                rakamButon("7", 1, Colors.white10, ekranYuksekligi),
                rakamButon("8", 1, Colors.white10, ekranYuksekligi),
                rakamButon("9", 1, Colors.white10, ekranYuksekligi),
                islemButon("x", 1, Colors.orange, ekranYuksekligi),
              ],
            ),
            Row(
              children: [
                rakamButon("4", 1, Colors.white10, ekranYuksekligi),
                rakamButon("5", 1, Colors.white10, ekranYuksekligi),
                rakamButon("6", 1, Colors.white10, ekranYuksekligi),
                islemButon("—", 1, Colors.orange, ekranYuksekligi),
              ],
            ),
            Row(
              children: [
                rakamButon("1", 1, Colors.white10, ekranYuksekligi),
                rakamButon("2", 1, Colors.white10, ekranYuksekligi),
                rakamButon("3", 1, Colors.white10, ekranYuksekligi),
                islemButon("+", 1, Colors.orange, ekranYuksekligi),
              ],
            ),
            Row(
              children: [
                rakamButon("0", 2, Colors.white10, ekranYuksekligi),
                // , BUTONU
                Expanded(
                    flex: 1,
                    child: Container( //container koymamızın sebebi yükseklik koymak ve margin koymak.
                      height: ekranYuksekligi/8.84,
                      margin: const EdgeInsets.all(3.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white10,),
                        onPressed: (){
                          setState(() {
                            if(sonIslem == "="){ // = bastıktan sonra basıtığımızda sıfırlansın her şey AC gibi.
                              butunIslemler = "0";
                              sonuc = 0;
                              gorunenSayi = "0";
                              sonIslem = "";
                              islemList.clear();
                            }
                            List<String> varmi = gorunenSayi.split('');
                            virgulDurum = !virgulDurum;
                            if((varmi[varmi.length-1] == ".")){ // Eğer en sonda gözüken . ise
                              if(!virgulDurum){ //false ise silsin dedik.
                                List<String> gorunenSayiKontrol = gorunenSayi.split('');
                                gorunenSayiKontrol.removeLast();
                                gorunenSayi = gorunenSayiKontrol.join('');
                                List<String> butunIslemlerKontrol = butunIslemler.split('');
                                butunIslemlerKontrol.removeLast();
                                butunIslemler = butunIslemlerKontrol.join('');
                              }
                            }else if(!(varmi.contains("."))){ // Eğer yoksa ve true ise eklesin dedik.
                              if(virgulDurum){
                                String kontrol = butunIslemler.substring(butunIslemler.length-1);
                                if(kontrol == "+" || kontrol == "—" || kontrol == "x" || kontrol == "/" || kontrol == "%"){
                                  gorunenSayi = "0";
                                }
                                gorunenSayi = "$gorunenSayi.";
                                butunIslemler = "$butunIslemler.";
                              }
                            }
                          });
                        }, child: Text(",", style: TextStyle(fontSize: ekranYuksekligi/23.58, color: Colors.white),),),
                    )
                ),
                // = BUTONU
                Expanded(
                    flex: 1,
                    child: Container( //container koymamızın sebebi yükseklik koymak ve margin koymak.
                      height: ekranYuksekligi/8.84,
                      margin: const EdgeInsets.all(3.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange,),
                        onPressed: (){
                          setState(() {
                            if(sonuc == 0){
                              sonuc = double.parse(gorunenSayi);
                            }else{
                              if(sonIslem == "+"){
                                sonuc += double.parse(gorunenSayi);
                              }else if(sonIslem == "—"){
                                sonuc -= double.parse(gorunenSayi);
                              }else if(sonIslem == "x"){
                                sonuc *= double.parse(gorunenSayi);
                              }else if(sonIslem == "/"){
                                sonuc /= double.parse(gorunenSayi);
                              } else if(sonIslem == "%"){
                                sonuc %= double.parse(gorunenSayi);
                              }
                            }
                            String kontrol = "$sonuc".substring("$sonuc".length-2, "$sonuc".length);
                            if(kontrol == ".0") {
                              gorunenSayi = "${sonuc.toInt()}";
                            }else{
                              gorunenSayi = "$sonuc";
                            }
                            sonIslem = "=";
                            virgulDurum = false;
                            negatifDurum = false;
                          });
                        }, child: Text("=", style: TextStyle(fontSize: ekranYuksekligi/23.58, color: Colors.white),),),
                    )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}