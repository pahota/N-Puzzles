#ifndef AUDIOCONTROLLER_H
#define AUDIOCONTROLLER_H

#include <QObject>
#include <QMediaPlayer>
#include <QAudioOutput>

class AudioController : public QObject
{
    Q_OBJECT
public:
    explicit AudioController(QObject *parent = nullptr);

    Q_INVOKABLE void playSound(const QString &source);
    Q_INVOKABLE void stop();
    Q_INVOKABLE void setVolume(qreal volume);
    Q_INVOKABLE void setLooping(bool loop);

private slots:
    void handleError(QMediaPlayer::Error error, const QString &errorString);
    void handleMediaStatusChanged(QMediaPlayer::MediaStatus status);

private:
    QMediaPlayer *m_mediaPlayer;
    QAudioOutput *m_audioOutput;
    QString m_currentSource;
    bool m_looping;
};

#endif // AUDIOCONTROLLER_H
