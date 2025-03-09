#include "audiocontroller.h"
#include <QDebug>

AudioController::AudioController(QObject *parent) : QObject(parent), m_looping(false)
{
    m_mediaPlayer = new QMediaPlayer(this);
    m_audioOutput = new QAudioOutput(this);
    m_mediaPlayer->setAudioOutput(m_audioOutput);

    connect(m_mediaPlayer, &QMediaPlayer::errorOccurred, this, &AudioController::handleError);
    connect(m_mediaPlayer, &QMediaPlayer::mediaStatusChanged, this, &AudioController::handleMediaStatusChanged);
}

void AudioController::playSound(const QString &source)
{
    m_mediaPlayer->stop();
    m_currentSource = source;

    QUrl url(source);
    m_mediaPlayer->setSource(url);
    m_mediaPlayer->play();
}

void AudioController::stop()
{
    m_mediaPlayer->stop();
}

void AudioController::setVolume(qreal volume)
{
    if (m_audioOutput) {
        m_audioOutput->setVolume(volume);
    }
}

void AudioController::setLooping(bool loop)
{
    m_looping = loop;
}

void AudioController::handleError(QMediaPlayer::Error error, const QString &errorString)
{
    qDebug() << "Media player error:" << error << "-" << errorString;
}

void AudioController::handleMediaStatusChanged(QMediaPlayer::MediaStatus status)
{
    if (status == QMediaPlayer::EndOfMedia && m_looping && !m_currentSource.isEmpty()) {
        m_mediaPlayer->setPosition(0);
        m_mediaPlayer->play();
    }
}
