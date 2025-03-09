#ifndef GAMEBOARDMODEL_H
#define GAMEBOARDMODEL_H

#include <QAbstractListModel>
#include "gameboard.h"

class GameBoardModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int boardSize READ boardSize NOTIFY boardSizeChanged)
    Q_PROPERTY(int dimension READ dimension WRITE setDimension NOTIFY dimensionChanged)
    Q_PROPERTY(int hiddenElementValue READ hiddenElementValue NOTIFY boardSizeChanged)
    Q_PROPERTY(int counter READ counter NOTIFY counterChanged)

public:
    explicit GameBoardModel(QObject* parent = nullptr);

    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;

    int boardSize() const;
    int dimension() const;
    void setDimension(int dim);
    int hiddenElementValue() const;
    int counter() const;

    Q_INVOKABLE bool move(int index);
    Q_INVOKABLE bool checkWin() const;
    Q_INVOKABLE void resetBoard();

signals:
    void boardSizeChanged();
    void dimensionChanged();
    void counterChanged();
    void gameWon();

private:
    GameBoard* m_board;
};

#endif
