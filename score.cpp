#include "score.h"
#include <QDebug>

Score::Score(QObject *parent)
    : QObject(parent),
    m_startingScore(10000),
    m_currentScore(10000),
    m_minimumScore(0),
    m_timeScorePenalty(50),
    m_moveScorePenalty(10)
{
    qDebug() << "Score object created with starting score:" << m_startingScore;
}

int Score::startingScore() const {
    return m_startingScore;
}

void Score::setStartingScore(int score) {
    if (m_startingScore != score) {
        m_startingScore = score;
        emit startingScoreChanged();
    }
}

int Score::currentScore() const {
    return m_currentScore;
}

void Score::setCurrentScore(int score) {
    if (m_currentScore != score) {
        m_currentScore = score;
        //qDebug() << "Current score changed to:" << m_currentScore;
        emit currentScoreChanged();
    }
}

int Score::minimumScore() const {
    return m_minimumScore;
}

void Score::setMinimumScore(int score) {
    if (m_minimumScore != score) {
        m_minimumScore = score;
        emit minimumScoreChanged();
    }
}

int Score::calculateScore(int elapsedTime, int moves) {
    int score = m_startingScore;
    score -= (elapsedTime / 5) * m_timeScorePenalty;
    score -= moves * m_moveScorePenalty;
    score = qMax(score, m_minimumScore);

    // qDebug() << "Calculating score: time=" << elapsedTime << ", moves=" << moves;
    // qDebug() << "Result score:" << score;

    setCurrentScore(score);
    return m_currentScore;
}

void Score::resetScore() {
    qDebug() << "Resetting score to starting value:" << m_startingScore;
    setCurrentScore(m_startingScore);
}
