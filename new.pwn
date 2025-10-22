========= FITUR DIALOG WELCOME ==========

// +(Include)
#include <crashdetect>

// +(Define)
#define DIALOG_WELCOME

// + Fugsi Public Baru
public OnPlayerWelcome(playerid)
{
    if(!PlayerLogged[playerid])
    {
        SendClientMessage(playerid, -1, "Kamu harus login terlebih dahulu.");
        return 1;
    }
    
    new title[64], body[500], b1[16];
    format(title, sizeof(title), "Info Warga Baru");
    format(body, sizeof(body), "Selamat datang di Kota Belajar Roleplay!\n\n");
    strcat(body, "Tugas wajib anda:\n");
    strcat(body, "1.Daftarkan identitas(ID-Card) anda.\n");
    strcat(body, "2.Ambil Modal Awal(Staterpack).\n\n");
    
    strcat(body, "Lokasi Tujuan:\n");
    strcat(body, "- Balaikota sebelah Kantor Polisi Los Santos.\n");
    strcat(body, "Silahkan cari di peta(map).\n\n");
    
    strcat(body, "Motor Vespa sudah kami siapkan didepan anda.\n");
    strcat(body, "Selamat Bermain:)");
    format(b1, sizeof(b1), "Mulai");
    
    ShowPlayerDialog(playerid, DIALOG_WELCOME, DIALOG_STYLE_MSGBOX, title, body, b1, "");
    return 1;
}

// + ( Fungsi Public OnDialogResponse)
if(dialogid == DIALOG_WELCOME)
   {
       return 1;
   }


========== FITUR KENDRAAAN + WAKTU ==========

// + Define Untuk Memunculkan Kendaraan
#define VEH_MODEL 462
#define VEH_X 1690.5836
#define VEH_Y -2323.7197
#define VEH_Z 13.3828
#define VEH_A 85.0
#define TEMP_VEH_DURATION 86400 

// + CMD /veh
CMD:veh(playerid, params[])
{
    if(!PlayerLogged[playerid])
    {
        SendClientMessage(playerid, -1, "Kamu harus login terlebih dahulu.");
        return 1;
    }
    
    new accpath[64];
    AccountPath(playerid, accpath, sizeof(accpath));
    
    new expiration_time = dini_Int(accpath, "TempVehExpire");
    
    if(expiration_time >0)
    {
        new current_time = gettime();
        
        if(current_time >= expiration_time)
        {
            dini_IntSet(accpath, "TempVehExpire", 0);
            SendClientMessage(playerid, -1, "Batas waktu 24 jam Vespa anda sudah berakhir.");
        }
        else
        {
            new remaining_seconds = expiration_time - current_time;
            new remaining_hours = remaining_seconds / 3600;
            new remaining_minutes = (remaining_seconds % 3600) / 60;
            
            new message[128];
            format(message, sizeof(message), "Status Vespa kamu aktif. Sisa waktu:%d jam %d menit.", remaining_hours, remaining_minutes);
            SendClientMessage(playerid, -1, message);
        }
    }
    else
    {
        SendClientMessage(playerid, -1, "Kamu tidak memiliki kendaraan. Silahkan sewa / beli.");
    }
    return 1;
}

// + (Public OnDialogResponse (Didalam Blok Kode "DIALOG_REGISTER"))
new expiration_time = gettime() + TEMP_VEH_DURATION;
dini_IntSet(accpath, "TempVehExpire", expiration_time);
SetTimerEx("OnPlayerWelcome", 1500, false, "d", playerid);
