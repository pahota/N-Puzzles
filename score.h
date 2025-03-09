#ifndef SCORE_H
#define SCORE_H

#include <QObject>

class Score : public QObject {
    Q_OBJECT
    Q_PROPERTY(int startingScore READ startingScore WRITE setStartingScore NOTIFY startingScoreChanged)
    Q_PROPERTY(int currentScore READ currentScore WRITE setCurrentScore NOTIFY currentScoreChanged)
    Q_PROPERTY(int minimumScore READ minimumScore WRITE setMinimumScore NOTIFY minimumScoreChanged)

public:
    explicit Score(QObject *parent = nullptr);

    int startingScore() const;
    void setStartingScore(int score);

    int currentScore() const;
    void setCurrentScore(int score);

    int minimumScore() const;
    void setMinimumScore(int score);

    Q_INVOKABLE int calculateScore(int elapsedTime, int moves);
    Q_INVOKABLE void resetScore();

signals:
    void startingScoreChanged();
    void currentScoreChanged();
    void minimumScoreChanged();

private:
    int m_startingScore;
    int m_currentScore;
    int m_minimumScore;
    int m_timeScorePenalty;
    int m_moveScorePenalty;
};

#endif // SCORE_H
