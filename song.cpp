#include "song.h"
#include <fstream>
#include <iostream>
#include <QDebug>
#include <id3/tag.h>
#include <QVariant>
#include <taglib/id3v1tag.h>
#include <taglib/id3v2tag.h>
#include <taglib/tag.h>
#include <taglib/mpegfile.h>
#include <taglib/flacfile.h>
#include <taglib/vorbisfile.h>
#include <taglib/xiphcomment.h>
#include <taglib/attachedpictureframe.h>
using namespace std;

Song::Song(QObject *parent) : QObject(parent)
{
    m_Tags["标题"]=" ";
    m_Tags["艺术家"]=" ";
    m_Tags["唱片集"]=" ";
    m_Tags["注释"]=" ";
    m_Tags["日期"]=" ";
    m_Tags["音轨号"]=" ";
    m_Tags["流派"]=" ";
}

void Song::getTags(QString url)
{
    QByteArray ba=url.toUtf8();
    const char *ch=ba.data();

    QString end;  //歌名后缀
    for(int i=url.length()-1;i>=0;i--) {
        if(url[i]==".") {
            end=url.mid(i+1,url.length()-i);
            break;
        }
    }
    if(end=="mp3") {
        mp3Open(ch);
    } else if(end=="flac"){
        flacOpen(ch);
    } else if(end=="ogg"){
        oggOpen(ch);
    }
}

void Song::saveTags(QString url,QVariantMap map)
{
    QByteArray ba=url.toUtf8();
    const char *ch=ba.data();

    QString end;
    for(int i=url.length()-1;i>=0;i--) {
        if(url[i]==".") {
            end=url.mid(i+1,url.length()-i);
            break;
        }
    }
    if(end=="mp3") {
        mp3Save(ch,map);
    } else if(end=="flac" || end=="ogg"){
        flacSave(ch,map);
    } else if(end=="ogg"){
        oggSave(ch,map);
    }
}

void Song::mp3Open(const char *ch)
{
    TagLib::MPEG::File *mpegFile = new TagLib::MPEG::File(ch);
    m_Tags.clear();

    if(mpegFile->isOpen()) {
        m_Tags["标题"]=mpegFile->tag()->title().toCString();
        m_Tags["艺术家"]=mpegFile->tag()->artist().toCString();
        m_Tags["唱片集"]=mpegFile->tag()->album().toCString();
        m_Tags["注释"]=mpegFile->tag()->comment().toCString();
        m_Tags["日期"]=mpegFile->tag()->year();
        m_Tags["音轨号"]=mpegFile->tag()->track();
        m_Tags["流派"]=mpegFile->tag()->genre().toCString();
    }
}

void Song::flacOpen(const char *ch)
{
    TagLib::FLAC::File *flacFile = new TagLib::FLAC::File(ch);
    m_Tags.clear();
    if(flacFile->isOpen()) {
        m_Tags["标题"]=flacFile->tag()->title().toCString();
        m_Tags["艺术家"]=flacFile->tag()->artist().toCString();
        m_Tags["唱片集"]=flacFile->tag()->album().toCString();
        m_Tags["注释"]=flacFile->tag()->comment().toCString();
        m_Tags["日期"]=flacFile->tag()->year();
        m_Tags["音轨号"]=flacFile->tag()->track();
        m_Tags["流派"]=flacFile->tag()->genre().toCString();
    }
}

void Song::oggOpen(const char *ch)
{
    TagLib::Vorbis::File *oggFile = new TagLib::Vorbis::File(ch);
    m_Tags.clear();
    if(oggFile->isOpen()) {
        m_Tags["标题"]=oggFile->tag()->title().toCString();
        m_Tags["艺术家"]=oggFile->tag()->artist().toCString();
        m_Tags["唱片集"]=oggFile->tag()->album().toCString();
        m_Tags["注释"]=oggFile->tag()->comment().toCString();
        m_Tags["日期"]=oggFile->tag()->year();
        m_Tags["音轨号"]=oggFile->tag()->track();
        m_Tags["流派"]=oggFile->tag()->genre().toCString();
    }
}

void Song::mp3Save(const char *ch, QVariantMap map)
{
    TagLib::String str;
    TagLib::MPEG::File *mpegFile = new TagLib::MPEG::File(ch);
    QByteArray ba;

    ba=map["标题"].toString().toUtf8();
    str=ba.data();
    mpegFile->tag()->setTitle(str);

    ba=map["艺人家"].toString().toUtf8();
    str=ba.data();
    mpegFile->tag()->setArtist(str);

    ba=map["唱片集"].toString().toUtf8();
    str=ba.data();
    mpegFile->tag()->setAlbum(str);

    ba=map["注释"].toString().toUtf8();
    str=ba.data();
    mpegFile->tag()->setComment(str);

    mpegFile->tag()->setYear(map["日期"].toUInt());

    mpegFile->tag()->setTrack(map["音轨号"].toUInt());

    ba=map["流派"].toString().toUtf8();
    str=ba.data();
    mpegFile->tag()->setGenre(str);
    qDebug()<<mpegFile->tag()->title().toCString();
    if(mpegFile->save()) {
        qDebug()<<"save successfully";
    } else {
        qDebug()<<"save field";
    }

}

void Song::flacSave(const char *ch,QVariantMap map)
{
    TagLib::FLAC::File *flacFile = new TagLib::FLAC::File(ch);
    QByteArray ba;
    TagLib::String str;

    ba=map["标题"].toString().toUtf8();
    str=ba.data();
    flacFile->tag()->setTitle(str);

    ba=map["艺术家"].toString().toUtf8();
    str=ba.data();
    flacFile->tag()->setArtist(str);

    ba=map["唱片集"].toString().toUtf8();
    str=ba.data();
    flacFile->tag()->setAlbum(str);

    ba=map["注释"].toString().toUtf8();
    str=ba.data();
    flacFile->tag()->setComment(str);

    flacFile->tag()->setYear(map["日期"].toUInt());

    flacFile->tag()->setTrack(map["音轨号"].toUInt());

    ba=map["流派"].toString().toUtf8();
    str=ba.data();
    flacFile->tag()->setGenre(str);

    qDebug()<<map["标题"].toString();
    if(flacFile->save()) {
        qDebug()<<"save successfully";
    } else {
        qDebug()<<"save field";
    }

}

void Song::oggSave(const char *ch,QVariantMap map)
{
    TagLib::FLAC::File *flacFile = new TagLib::FLAC::File(ch);
    QByteArray ba;
    TagLib::String str;

    ba=map["标题"].toString().toUtf8();
    str=ba.data();
    flacFile->tag()->setTitle(str);

    ba=map["艺术家"].toString().toUtf8();
    str=ba.data();
    flacFile->tag()->setArtist(str);

    ba=map["唱片集"].toString().toUtf8();
    str=ba.data();
    flacFile->tag()->setAlbum(str);

    ba=map["注释"].toString().toUtf8();
    str=ba.data();
    flacFile->tag()->setComment(str);

    flacFile->tag()->setYear(map["日期"].toUInt());

    flacFile->tag()->setTrack(map["音轨号"].toUInt());

    ba=map["流派"].toString().toUtf8();
    str=ba.data();
    flacFile->tag()->setGenre(str);

    qDebug()<<map["标题"].toString();
    if(flacFile->save()) {
        qDebug()<<"save successfully";
    } else {
        qDebug()<<"save field";
    }
}
